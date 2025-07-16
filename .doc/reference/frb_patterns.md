# Flutter Rust Bridge Patterns for Quinn

## Core API Implementation (Priority 1)

### Direct Quinn Wrappers
```rust
// Rust side - Direct Quinn mapping
#[frb(opaque)]
pub struct QuicEndpoint(quinn::Endpoint);

#[frb(opaque)]
pub struct QuicConnection(quinn::Connection);

#[frb(opaque)]
pub struct QuicSendStream(quinn::SendStream);

#[frb(opaque)]
pub struct QuicRecvStream(quinn::RecvStream);

impl QuicEndpoint {
    pub async fn client(config: ClientConfig) -> Result<QuicEndpoint, EndpointError> {
        let endpoint = quinn::Endpoint::client(config)?;
        Ok(QuicEndpoint(endpoint))
    }
    
    pub async fn connect(&self, addr: String, server_name: String) -> Result<QuicConnection, ConnectError> {
        let connection = self.0.connect(addr.parse()?, &server_name)?.await?;
        Ok(QuicConnection(connection))
    }
}

impl QuicConnection {
    pub async fn open_bi(&self) -> Result<(QuicSendStream, QuicRecvStream), ConnectionError> {
        let (send, recv) = self.0.open_bi().await?;
        Ok((QuicSendStream(send), QuicRecvStream(recv)))
    }
    
    pub async fn send_datagram(&self, data: Vec<u8>) -> Result<(), SendDatagramError> {
        self.0.send_datagram(data.into())?;
        Ok(())
    }
}
```

---

## Convenience API Implementation (Priority 2)

### QuicClient Structure
```rust
#[frb(opaque)]
pub struct QuicClient {
    endpoint: quinn::Endpoint,
    config: QuicConfig,
    connection_pool: HashMap<String, quinn::Connection>,
}

#[derive(Clone)]
pub struct QuicConfig {
    pub timeout: Duration,
    pub keep_alive: bool,
    pub max_connections: usize,
    pub retry_attempts: u32,
    pub alpn_protocols: Vec<Vec<u8>>,
}

impl QuicClient {
    pub fn new(config: QuicConfig) -> Result<QuicClient, QuicClientError> {
        let mut client_config = ClientConfig::with_native_roots()
            .with_alpn_protocols(&config.alpn_protocols);
        
        let endpoint = quinn::Endpoint::client(
            SocketAddr::from(([0, 0, 0, 0], 0))
        )?;
        
        Ok(QuicClient {
            endpoint,
            config,
            connection_pool: HashMap::new(),
        })
    }
    
    pub async fn send(&mut self, url: String, data: Vec<u8>) -> Result<Vec<u8>, QuicClientError> {
        let connection = self.get_or_create_connection(&url).await?;
        
        let (mut send_stream, mut recv_stream) = connection.open_bi().await?;
        
        send_stream.write_all(&data).await?;
        send_stream.finish().await?;
        
        let response = recv_stream.read_to_end(1024 * 1024).await?;
        Ok(response)
    }
    
    pub async fn get(&mut self, url: String) -> Result<Vec<u8>, QuicClientError> {
        self.send(url, Vec::new()).await
    }
    
    pub async fn post(&mut self, url: String, data: Vec<u8>) -> Result<Vec<u8>, QuicClientError> {
        self.send(url, data).await
    }
    
    async fn get_or_create_connection(&mut self, url: &str) -> Result<&quinn::Connection, QuicClientError> {
        if let Some(connection) = self.connection_pool.get(url) {
            if !connection.close_reason().is_some() {
                return Ok(connection);
            }
        }
        
        let parsed_url = url.parse::<Uri>()?;
        let host = parsed_url.host().ok_or(QuicClientError::InvalidUrl)?;
        let port = parsed_url.port_u16().unwrap_or(4433);
        let addr = format!("{}:{}", host, port);
        
        let connecting = self.endpoint.connect(addr.parse()?, host)?;
        let connection = connecting.await?;
        
        self.connection_pool.insert(url.to_string(), connection);
        Ok(self.connection_pool.get(url).unwrap())
    }
}

#[derive(Debug, thiserror::Error)]
pub enum QuicClientError {
    #[error("Quinn connection error: {0}")]
    Connection(#[from] quinn::ConnectionError),
    #[error("Quinn connect error: {0}")]
    Connect(#[from] quinn::ConnectError),
    #[error("Invalid URL: {0}")]
    InvalidUrl,
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
}
```

### Dart Side Usage
```dart
// Production QuicClient usage
final client = QuicClient(
  config: QuicConfig(
    timeout: Duration(seconds: 30),
    keepAlive: true,
    maxConnections: 10,
    retryAttempts: 3,
    alpnProtocols: ['h3'],
  ),
);

// Real API calls
final response = await client.post(
  'https://api.myservice.com:4433/users',
  data: jsonEncode({'name': 'John', 'email': 'john@example.com'}),
);

final users = await client.get('https://api.myservice.com:4433/users');
```

---

## Core API Patterns

## Core Wrapper Pattern

### Rust Side - Opaque Objects
```rust
use flutter_rust_bridge::frb;

#[frb(opaque)]
pub struct QuicEndpoint(quinn::Endpoint);

#[frb(opaque)]
pub struct QuicConnection(quinn::Connection);

#[frb(opaque)]
pub struct QuicSendStream(quinn::SendStream);

#[frb(opaque)]
pub struct QuicRecvStream(quinn::RecvStream);
```

### Flutter Side - Opaque Handles
```dart
class QuicEndpoint {
  // Opaque Rust object handle
  // Automatically managed by flutter_rust_bridge
}

class QuicConnection {
  // Opaque Rust object handle
  // Automatically managed by flutter_rust_bridge
}
```

## Async Method Patterns

### Pattern 1: Future<Result<T, E>> → Future<T>
```rust
// Rust implementation
impl QuicConnection {
    pub async fn open_bi(&self) -> Result<(QuicSendStream, QuicRecvStream), String> {
        let (send, recv) = self.0.open_bi().await
            .map_err(|e| format!("Failed to open bi stream: {}", e))?;
        Ok((QuicSendStream(send), QuicRecvStream(recv)))
    }
}
```

```dart
// Flutter usage
try {
  final (sendStream, recvStream) = await connection.openBi();
  // Use streams
} catch (e) {
  print('Error opening stream: $e');
}
```

### Pattern 2: Immediate Results
```rust
// Rust implementation
impl QuicConnection {
    pub fn remote_address(&self) -> String {
        self.0.remote_address().to_string()
    }
    
    pub fn stable_id(&self) -> u64 {
        self.0.stable_id() as u64
    }
}
```

```dart
// Flutter usage
final address = connection.remoteAddress();
final id = connection.stableId();
```

## Error Handling Strategy

### Rust Error Conversion
```rust
// Convert Quinn errors to String for simplicity
impl From<quinn::ConnectionError> for String {
    fn from(err: quinn::ConnectionError) -> Self {
        format!("Connection error: {}", err)
    }
}

impl From<quinn::WriteError> for String {
    fn from(err: quinn::WriteError) -> Self {
        format!("Write error: {}", err)
    }
}

impl From<quinn::ReadError> for String {
    fn from(err: quinn::ReadError) -> Self {
        format!("Read error: {}", err)
    }
}
```

### Flutter Error Handling
```dart
// All errors become Dart exceptions
try {
  await stream.writeAll(data);
} on PlatformException catch (e) {
  if (e.code == 'WriteError') {
    print('Write failed: ${e.message}');
  }
}
```

## Data Type Mappings

### Bytes and Buffers
```rust
// Rust side
impl QuicSendStream {
    pub async fn write_all(&self, data: Vec<u8>) -> Result<(), String> {
        self.0.write_all(&data).await
            .map_err(|e| e.to_string())
    }
}

impl QuicRecvStream {
    pub async fn read_to_end(&self, max_size: u64) -> Result<Vec<u8>, String> {
        self.0.read_to_end(max_size as usize).await
            .map_err(|e| e.to_string())
    }
}
```

```dart
// Flutter side
final data = Uint8List.fromList([1, 2, 3, 4]);
await sendStream.writeAll(data);

final received = await recvStream.readToEnd(1024);
```

### Configuration Objects
```rust
// Rust side - Builder pattern
pub struct QuicClientConfigBuilder {
    inner: quinn::ClientConfigBuilder,
}

impl QuicClientConfigBuilder {
    pub fn new() -> Self {
        Self {
            inner: quinn::ClientConfigBuilder::new(),
        }
    }
    
    pub fn with_native_roots(mut self) -> Self {
        self.inner = self.inner.with_native_roots();
        self
    }
    
    pub fn build(self) -> Result<QuicClientConfig, String> {
        let config = self.inner.build()
            .map_err(|e| e.to_string())?;
        Ok(QuicClientConfig(config))
    }
}
```

```dart
// Flutter side - Builder pattern
final config = QuicClientConfigBuilder()
    .withNativeRoots()
    .build();
```

## Stream Operations

### Reading Pattern
```rust
impl QuicRecvStream {
    pub async fn read(&self, max_size: u32) -> Result<Option<Vec<u8>>, String> {
        let mut buf = vec![0u8; max_size as usize];
        match self.0.read(&mut buf).await {
            Ok(Some(n)) => {
                buf.truncate(n);
                Ok(Some(buf))
            }
            Ok(None) => Ok(None),
            Err(e) => Err(e.to_string()),
        }
    }
}
```

```dart
// Flutter side
while (true) {
  final chunk = await recvStream.read(1024);
  if (chunk == null) break; // Stream ended
  processData(chunk);
}
```

### Writing Pattern
```rust
impl QuicSendStream {
    pub async fn write(&self, data: Vec<u8>) -> Result<u64, String> {
        let written = self.0.write(&data).await
            .map_err(|e| e.to_string())?;
        Ok(written as u64)
    }
    
    pub async fn finish(&self) -> Result<(), String> {
        self.0.finish().await
            .map_err(|e| e.to_string())
    }
}
```

```dart
// Flutter side
final written = await sendStream.write(data);
await sendStream.finish();
```

## Lifecycle Management

### Automatic Cleanup
```rust
// flutter_rust_bridge handles Drop automatically
impl Drop for QuicConnection {
    fn drop(&mut self) {
        // Connection cleanup happens automatically
        // No manual intervention needed
    }
}
```

### Resource Management
```dart
// Flutter side - resources cleaned up automatically
class MyQuicClient {
  QuicConnection? _connection;
  
  Future<void> connect() async {
    _connection = await endpoint.connect(address, serverName);
  }
  
  void dispose() {
    // Resources automatically cleaned up when references dropped
    _connection = null;
  }
}
```

## Advanced Patterns

### Callback/Stream Integration
```rust
// For continuous data streams
impl QuicConnection {
    pub async fn datagram_stream(&self) -> impl Stream<Item = Result<Vec<u8>, String>> {
        // Return async stream of datagrams
        // flutter_rust_bridge converts to Dart Stream
    }
}
```

```dart
// Flutter side
await for (final datagram in connection.datagramStream()) {
  processDatagram(datagram);
}
```

### Configuration Validation
```rust
// Validate configuration at build time
impl QuicEndpointConfig {
    pub fn validate(&self) -> Result<(), String> {
        // Validate configuration
        // Return descriptive error messages
        Ok(())
    }
}
```

```dart
// Flutter side
try {
  final config = endpointConfigBuilder.build();
  await config.validate();
} catch (e) {
  print('Configuration error: $e');
}
```

---
*Patterns for Quinn 0.11.x + flutter_rust_bridge 2.x* 