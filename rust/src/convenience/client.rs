//! Convenience Client API - Simple QUIC client interface

use flutter_rust_bridge::frb;
use crate::core::{QuicEndpoint, QuicConnection};
use crate::errors::QuicError;
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};
use url::Url;

/// Configuration for QuicClient
#[derive(Debug, Clone)]
pub struct QuicClientConfig {
    /// Maximum number of connections per host
    pub max_connections_per_host: usize,
    /// Connection timeout in milliseconds
    pub connect_timeout_ms: u64,
    /// Request timeout in milliseconds
    pub request_timeout_ms: u64,
    /// Number of retry attempts for failed requests
    pub retry_attempts: u32,
    /// Retry delay in milliseconds
    pub retry_delay_ms: u64,
    /// Keep-alive timeout for connections in milliseconds
    pub keep_alive_timeout_ms: u64,
}

impl Default for QuicClientConfig {
    fn default() -> Self {
        Self {
            max_connections_per_host: 10,
            connect_timeout_ms: 5000,
            request_timeout_ms: 30000,
            retry_attempts: 3,
            retry_delay_ms: 1000,
            keep_alive_timeout_ms: 60000,
        }
    }
}

/// Entry in the connection pool
#[derive(Debug)]
struct PooledConnection {
    connection: QuicConnection,
    last_used: Instant,
    host: String,
}

/// High-level QUIC client with Dio-style interface
/// 
/// QuicClient provides a simple HTTP-like interface built on top of the Core API,
/// with automatic connection pooling, retries, and simplified configuration.
/// 
/// # Example
/// ```dart
/// final client = QuicClient.create();
/// final response = await client.send('https://example.com/api/data', data);
/// ```
#[frb(opaque)]
pub struct QuicClient {
    endpoint: QuicEndpoint,
    config: QuicClientConfig,
    // Connection pool keyed by host:port
    pool: Arc<Mutex<HashMap<String, Vec<PooledConnection>>>>,
}

impl QuicClient {
    /// Create a new QuicClient with default configuration
    /// 
    /// Creates a client endpoint and initializes the connection pool.
    /// Uses insecure configuration suitable for testing.
    pub fn create() -> Result<Self, QuicError> {
        let endpoint = QuicEndpoint::client()?;
        let config = QuicClientConfig::default();
        let pool = Arc::new(Mutex::new(HashMap::new()));
        
        Ok(Self {
            endpoint,
            config,
            pool,
        })
    }
    
    /// Create a new QuicClient with custom configuration
    /// 
    /// # Arguments
    /// * `config` - Custom configuration for the client
    pub fn create_with_config(config: QuicClientConfig) -> Result<Self, QuicError> {
        let endpoint = QuicEndpoint::client()?;
        let pool = Arc::new(Mutex::new(HashMap::new()));
        
        Ok(Self {
            endpoint,
            config,
            pool,
        })
    }
    
    /// Get or create a connection to the specified host
    /// 
    /// This method implements connection pooling - it will reuse existing
    /// connections when possible or create new ones when needed.
    /// 
    /// # Arguments
    /// * `url` - Target URL to connect to
    async fn get_connection(&self, url: &str) -> Result<QuicConnection, QuicError> {
        let parsed_url = Url::parse(url)
            .map_err(|e| QuicError::Connection(format!("Invalid URL: {:?}", e)))?;
        
        let host = parsed_url.host_str()
            .ok_or_else(|| QuicError::Connection("URL must contain a host".to_string()))?;
        
        let port = parsed_url.port().unwrap_or(443);
        let host_key = format!("{}:{}", host, port);
        let addr = format!("{}:{}", host, port);
        
        // Try to get an existing connection from the pool
        {
            let mut pool = self.pool.lock().unwrap();
            if let Some(connections) = pool.get_mut(&host_key) {
                // Remove expired connections
                let now = Instant::now();
                let keep_alive_duration = Duration::from_millis(self.config.keep_alive_timeout_ms);
                connections.retain(|conn| now.duration_since(conn.last_used) < keep_alive_duration);
                
                // Try to reuse an existing connection
                if let Some(mut pooled_conn) = connections.pop() {
                    pooled_conn.last_used = now;
                    connections.push(pooled_conn);
                    return Ok(connections.last().unwrap().connection.clone());
                }
            }
        }
        
        // Create a new connection
        let connection = self.endpoint.connect(addr, host.to_string()).await?;
        
        // Add to pool
        {
            let mut pool = self.pool.lock().unwrap();
            let connections = pool.entry(host_key.clone()).or_insert_with(Vec::new);
            
            // Limit connections per host
            if connections.len() >= self.config.max_connections_per_host {
                connections.remove(0); // Remove oldest connection
            }
            
            connections.push(PooledConnection {
                connection: connection.clone(),
                last_used: Instant::now(),
                host: host_key,
            });
        }
        
        Ok(connection)
    }
    
    /// Get the current configuration
    pub fn config(&self) -> QuicClientConfig {
        self.config.clone()
    }
    
    /// Update the client configuration
    pub fn set_config(&mut self, config: QuicClientConfig) {
        self.config = config;
    }
    
    /// Get connection pool statistics
    /// 
    /// Returns information about the current state of the connection pool.
    pub fn pool_stats(&self) -> HashMap<String, usize> {
        let pool = self.pool.lock().unwrap();
        pool.iter()
            .map(|(host, connections)| (host.clone(), connections.len()))
            .collect()
    }
    
    /// Clear all connections from the pool
    /// 
    /// Forces all future requests to create new connections.
    pub fn clear_pool(&self) {
        let mut pool = self.pool.lock().unwrap();
        pool.clear();
    }
    
    /// Send data to a URL and return the response
    /// 
    /// This is the core method providing a Dio-style interface for QUIC requests.
    /// It handles connection pooling, retries, and provides a simple request/response pattern.
    /// 
    /// # Arguments
    /// * `url` - Target URL (e.g., "https://example.com/api/data")
    /// * `data` - Data to send (will be sent as bytes over QUIC stream)
    /// 
    /// # Returns
    /// * `Ok(String)` - Response data as UTF-8 string
    /// * `Err(QuicError)` - Connection, stream, or network errors
    /// 
    /// # Example
    /// ```dart
    /// final client = QuicClient.create();
    /// final response = await client.send('https://api.example.com/data', 'Hello QUIC!');
    /// print('Response: $response');
    /// ```
    pub async fn send(&self, url: String, data: String) -> Result<String, QuicError> {
        let mut last_error = QuicError::Connection("No attempts made".to_string());
        
        // Retry logic with configurable attempts
        for attempt in 0..=self.config.retry_attempts {
            match self.send_once(&url, &data).await {
                Ok(response) => return Ok(response),
                Err(error) => {
                    last_error = error;
                    
                    // Don't retry on final attempt
                    if attempt < self.config.retry_attempts {
                        // Check if error is retryable
                        if self.is_retryable_error(&last_error) {
                            // Wait before retry
                            let delay = Duration::from_millis(
                                self.config.retry_delay_ms * (attempt as u64 + 1)
                            );
                            tokio::time::sleep(delay).await;
                            continue;
                        } else {
                            // Non-retryable error, fail immediately
                            break;
                        }
                    }
                }
            }
        }
        
        Err(last_error)
    }
    
    /// Perform a single send attempt without retries
    async fn send_once(&self, url: &str, data: &str) -> Result<String, QuicError> {
        // Get or create connection using our pooling logic
        let connection = self.get_connection(url).await?;
        
        // Open a bidirectional stream for request/response
        let (mut send_stream, mut recv_stream) = connection.open_bi().await?;
        
        // Send the request data
        let request_bytes = data.as_bytes().to_vec();
        send_stream.write_all(request_bytes).await
            .map_err(|e| QuicError::Stream(format!("Failed to send data: {:?}", e)))?;
        
        // Finish sending (signals end of request)
        send_stream.finish()
            .map_err(|e| QuicError::Stream(format!("Failed to finish send stream: {:?}", e)))?;
        
        // Read the response with a reasonable size limit (1MB)
        let response_bytes = recv_stream.read_to_end(1024 * 1024).await
            .map_err(|e| QuicError::Stream(format!("Failed to read response: {:?}", e)))?;
        
        // Convert response to UTF-8 string
        let response = String::from_utf8(response_bytes)
            .map_err(|e| QuicError::Stream(format!("Response is not valid UTF-8: {:?}", e)))?;
        
        Ok(response)
    }
    
    /// Check if an error is retryable
    /// 
    /// Determines whether a failed request should be retried based on the error type.
    /// Network timeouts and connection issues are retryable, but authentication
    /// and protocol errors are not.
    fn is_retryable_error(&self, error: &QuicError) -> bool {
        match error {
            // Retryable connection errors
            QuicError::Connection(msg) => {
                // Check for timeout or network-related errors
                msg.contains("timeout") || 
                msg.contains("refused") || 
                msg.contains("unreachable") ||
                msg.contains("Failed to establish connection")
            },
            
            // Retryable network errors
            QuicError::Network(_) => true,
            
            // Retryable stream errors (connection might have been lost)
            QuicError::Stream(msg) => {
                msg.contains("ConnectionLost") || 
                msg.contains("connection lost") ||
                msg.contains("Failed to send data")
            },
            
            // Non-retryable errors
            QuicError::Config(_) => false,
            QuicError::Tls(_) => false,
            QuicError::Endpoint(_) => false,
            QuicError::Write(_) => false,
        }
    }
    
    /// Send data with timeout
    /// 
    /// Wraps the send operation with a configurable timeout to prevent hanging requests.
    pub async fn send_with_timeout(&self, url: String, data: String) -> Result<String, QuicError> {
        let timeout_duration = Duration::from_millis(self.config.request_timeout_ms);
        
        match tokio::time::timeout(timeout_duration, self.send(url, data)).await {
            Ok(result) => result,
            Err(_) => Err(QuicError::Network("Request timed out".to_string())),
        }
    }
    
    /// Send a GET request to the specified URL
    /// 
    /// This provides an HTTP-like interface for simple GET requests without data.
    /// Internally uses the send() method with empty data.
    /// 
    /// # Arguments
    /// * `url` - Target URL (e.g., "https://api.example.com/users")
    /// 
    /// # Returns
    /// * `Ok(String)` - Response data as UTF-8 string
    /// * `Err(QuicError)` - Connection, stream, or network errors
    /// 
    /// # Example
    /// ```dart
    /// final client = QuicClient.create();
    /// final users = await client.get('https://api.example.com/users');
    /// print('Users: $users');
    /// ```
    pub async fn get(&self, url: String) -> Result<String, QuicError> {
        // GET requests typically don't send data, so we use empty string
        self.send(url, String::new()).await
    }
    
    /// Send a POST request with data to the specified URL
    /// 
    /// This provides an HTTP-like interface for POST requests with data payload.
    /// Internally uses the send() method.
    /// 
    /// # Arguments
    /// * `url` - Target URL (e.g., "https://api.example.com/users")
    /// * `data` - Data to send in the request body (JSON, form data, etc.)
    /// 
    /// # Returns
    /// * `Ok(String)` - Response data as UTF-8 string
    /// * `Err(QuicError)` - Connection, stream, or network errors
    /// 
    /// # Example
    /// ```dart
    /// final client = QuicClient.create();
    /// final newUser = await client.post(
    ///   'https://api.example.com/users',
    ///   '{"name": "John", "email": "john@example.com"}'
    /// );
    /// print('Created user: $newUser');
    /// ```
    pub async fn post(&self, url: String, data: String) -> Result<String, QuicError> {
        // POST requests send data, so we pass it directly to send()
        self.send(url, data).await
    }
    
    /// Send a GET request with timeout
    /// 
    /// Combines the convenience of get() with timeout protection.
    pub async fn get_with_timeout(&self, url: String) -> Result<String, QuicError> {
        let timeout_duration = Duration::from_millis(self.config.request_timeout_ms);
        
        match tokio::time::timeout(timeout_duration, self.get(url)).await {
            Ok(result) => result,
            Err(_) => Err(QuicError::Network("GET request timed out".to_string())),
        }
    }
    
    /// Send a POST request with timeout
    /// 
    /// Combines the convenience of post() with timeout protection.
    pub async fn post_with_timeout(&self, url: String, data: String) -> Result<String, QuicError> {
        let timeout_duration = Duration::from_millis(self.config.request_timeout_ms);
        
        match tokio::time::timeout(timeout_duration, self.post(url, data)).await {
            Ok(result) => result,
            Err(_) => Err(QuicError::Network("POST request timed out".to_string())),
        }
    }
}

// Quinn Connection already implements Clone, so we can derive it for QuicConnection
impl Clone for QuicConnection {
    fn clone(&self) -> Self {
        // Quinn connections can be safely cloned - they represent handles to the same connection
        QuicConnection::new(self.inner().clone())
    }
} 