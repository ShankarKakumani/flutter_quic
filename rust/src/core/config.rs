//! Configuration builders for QUIC endpoints and connections

use flutter_rust_bridge::frb;
use std::sync::Arc;
use std::time::Duration;

/// QUIC Server Configuration
#[frb(opaque)]
pub struct QuicServerConfig {
    inner: quinn::ServerConfig,
}

impl QuicServerConfig {
    /// Create a new server config with a single certificate chain and key
    pub fn with_single_cert(
        cert_chain: Vec<Vec<u8>>,
        key: Vec<u8>,
    ) -> Result<Self, String> {
        use rustls_pki_types::{CertificateDer, PrivateKeyDer};
        
        // Convert Vec<Vec<u8>> to Vec<CertificateDer>
        let cert_chain: Vec<CertificateDer> = cert_chain
            .into_iter()
            .map(|cert| CertificateDer::from(cert))
            .collect();
        
        // Convert key bytes to PrivateKeyDer
        let private_key = PrivateKeyDer::try_from(key)
            .map_err(|e| format!("Invalid private key: {:?}", e))?;
        
        let server_config = quinn::ServerConfig::with_single_cert(cert_chain, private_key)
            .map_err(|e| format!("Failed to create server config: {:?}", e))?;
        
        Ok(Self { inner: server_config })
    }
    
    /// Create a new server config with a crypto provider and certificate
    pub fn with_crypto(
        cert_chain: Vec<Vec<u8>>,
        key: Vec<u8>,
        alpn_protocols: Vec<Vec<u8>>,
    ) -> Result<Self, String> {
        use rustls_pki_types::{CertificateDer, PrivateKeyDer};
        use rustls::ServerConfig as RustlsServerConfig;
        
        // Convert certificate chain
        let cert_chain: Vec<CertificateDer> = cert_chain
            .into_iter()
            .map(|cert| CertificateDer::from(cert))
            .collect();
        
        // Convert private key
        let private_key = PrivateKeyDer::try_from(key)
            .map_err(|e| format!("Invalid private key: {:?}", e))?;
        
        // Create rustls config
        let mut crypto_config = RustlsServerConfig::builder()
            .with_no_client_auth()
            .with_single_cert(cert_chain, private_key)
            .map_err(|e| format!("Failed to create TLS config: {:?}", e))?;
        
        crypto_config.alpn_protocols = alpn_protocols;
        
        let server_config = quinn::ServerConfig::with_crypto(Arc::new(
            quinn::crypto::rustls::QuicServerConfig::try_from(crypto_config)
                .map_err(|e| format!("Failed to create QUIC server config: {:?}", e))?
        ));
        
        Ok(Self { inner: server_config })
    }
    
    /// Get the inner Quinn ServerConfig
    pub(crate) fn inner(&self) -> &quinn::ServerConfig {
        &self.inner
    }
    
    /// Convert to Quinn ServerConfig
    pub fn into_inner(self) -> quinn::ServerConfig {
        self.inner
    }
}

/// QUIC Transport Configuration
#[frb(opaque)]
pub struct QuicTransportConfig {
    inner: quinn::TransportConfig,
}

impl QuicTransportConfig {
    /// Create a new transport config with default settings
    pub fn new() -> Self {
        Self {
            inner: quinn::TransportConfig::default(),
        }
    }
    
    /// Set the maximum number of concurrent bidirectional streams
    pub fn max_concurrent_bidi_streams(&mut self, count: u32) -> Result<(), String> {
        self.inner
            .max_concurrent_bidi_streams(quinn::VarInt::from_u32(count));
        Ok(())
    }
    
    /// Set the maximum number of concurrent unidirectional streams
    pub fn max_concurrent_uni_streams(&mut self, count: u32) -> Result<(), String> {
        self.inner
            .max_concurrent_uni_streams(quinn::VarInt::from_u32(count));
        Ok(())
    }
    
    /// Set the maximum idle timeout
    pub fn max_idle_timeout(&mut self, timeout_ms: Option<u64>) -> Result<(), String> {
        let timeout = timeout_ms.map(|ms| {
            quinn::IdleTimeout::try_from(Duration::from_millis(ms))
        }).transpose()
        .map_err(|e| format!("Invalid idle timeout: {:?}", e))?;
        
        self.inner
            .max_idle_timeout(timeout);
        Ok(())
    }
    
    /// Set the stream receive window size
    pub fn stream_receive_window(&mut self, size: u32) -> Result<(), String> {
        self.inner
            .stream_receive_window(quinn::VarInt::from_u32(size));
        Ok(())
    }
    
    /// Set the connection receive window size  
    pub fn receive_window(&mut self, size: u32) -> Result<(), String> {
        self.inner
            .receive_window(quinn::VarInt::from_u32(size));
        Ok(())
    }
    
    /// Set the send window size
    pub fn send_window(&mut self, size: u64) -> &mut Self {
        self.inner.send_window(size);
        self
    }
    
    /// Set the initial RTT estimate
    pub fn initial_rtt(&mut self, rtt_ms: u64) -> &mut Self {
        self.inner.initial_rtt(Duration::from_millis(rtt_ms));
        self
    }
    
    /// Set the keep-alive interval
    pub fn keep_alive_interval(&mut self, interval_ms: Option<u64>) -> &mut Self {
        let interval = interval_ms.map(Duration::from_millis);
        self.inner.keep_alive_interval(interval);
        self
    }
    
    /// Enable or disable the spin bit
    pub fn allow_spin(&mut self, allow: bool) -> &mut Self {
        self.inner.allow_spin(allow);
        self
    }
    
    /// Set the datagram receive buffer size
    pub fn datagram_receive_buffer_size(&mut self, size: Option<usize>) -> &mut Self {
        self.inner.datagram_receive_buffer_size(size);
        self
    }
    
    /// Set the datagram send buffer size
    pub fn datagram_send_buffer_size(&mut self, size: usize) -> &mut Self {
        self.inner.datagram_send_buffer_size(size);
        self
    }
    
    /// Get the inner Quinn TransportConfig
    pub(crate) fn inner(&self) -> &quinn::TransportConfig {
        &self.inner
    }
    
    /// Convert to Quinn TransportConfig
    pub fn into_inner(self) -> quinn::TransportConfig {
        self.inner
    }
}

impl Default for QuicTransportConfig {
    fn default() -> Self {
        Self::new()
    }
}

/// QUIC Endpoint Configuration
#[frb(opaque)]
pub struct QuicEndpointConfig {
    inner: quinn::EndpointConfig,
}

impl QuicEndpointConfig {
    /// Create a new endpoint config with default settings
    pub fn new() -> Self {
        Self {
            inner: quinn::EndpointConfig::default(),
        }
    }
    
    /// Set the maximum UDP payload size
    pub fn max_udp_payload_size(&mut self, size: u16) -> Result<(), String> {
        self.inner
            .max_udp_payload_size(size)
            .map_err(|e| format!("Invalid UDP payload size: {:?}", e))?;
        Ok(())
    }
    
    /// Get the current maximum UDP payload size
    pub fn get_max_udp_payload_size(&self) -> u64 {
        self.inner.get_max_udp_payload_size()
    }
    
    /// Set supported QUIC versions
    pub fn supported_versions(&mut self, versions: Vec<u32>) -> &mut Self {
        self.inner.supported_versions(versions);
        self
    }
    
    /// Enable or disable QUIC bit greasing
    pub fn grease_quic_bit(&mut self, enabled: bool) -> &mut Self {
        self.inner.grease_quic_bit(enabled);
        self
    }
    
    /// Set the minimum reset interval
    pub fn min_reset_interval(&mut self, interval_ms: u64) -> &mut Self {
        self.inner.min_reset_interval(Duration::from_millis(interval_ms));
        self
    }
    
    /// Set the RNG seed for deterministic behavior (testing only)
    pub fn rng_seed(&mut self, seed: Option<Vec<u8>>) -> Result<(), String> {
        let seed_array = if let Some(seed_vec) = seed {
            if seed_vec.len() != 32 {
                return Err("RNG seed must be exactly 32 bytes".to_string());
            }
            let mut array = [0u8; 32];
            array.copy_from_slice(&seed_vec);
            Some(array)
        } else {
            None
        };
        
        self.inner.rng_seed(seed_array);
        Ok(())
    }
    
    /// Get the inner Quinn EndpointConfig
    pub(crate) fn inner(&self) -> &quinn::EndpointConfig {
        &self.inner
    }
    
    /// Convert to Quinn EndpointConfig
    pub fn into_inner(self) -> quinn::EndpointConfig {
        self.inner
    }
}

impl Default for QuicEndpointConfig {
    fn default() -> Self {
        Self::new()
    }
} 