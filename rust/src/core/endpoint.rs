//! Core Endpoint API - Direct Quinn endpoint wrapper

use flutter_rust_bridge::frb;
use crate::core::connection::QuicConnection;
use crate::errors::QuicError;
use std::net::{SocketAddr, Ipv4Addr};
use std::sync::Arc;

#[frb(opaque)]
pub struct QuicEndpoint {
    inner: quinn::Endpoint,
}

impl QuicEndpoint {
    /// Create a new server endpoint with the given configuration
    pub fn server(config: crate::core::config::QuicServerConfig, addr: String) -> Result<Self, QuicError> {
        let rt = tokio::runtime::Runtime::new()
            .map_err(|e| QuicError::Endpoint(format!("Failed to create runtime: {:?}", e)))?;
        
        rt.block_on(async {
            let addr: SocketAddr = addr.parse()
                .map_err(|e| QuicError::Config(format!("Invalid address: {:?}", e)))?;
            
            let endpoint = quinn::Endpoint::server(config.into_inner(), addr)
                .map_err(|e| QuicError::Endpoint(format!("Failed to create server endpoint: {:?}", e)))?;
            
            Ok(Self { inner: endpoint })
        })
    }

    /// Create a new client endpoint with insecure configuration (for testing)
    pub fn client() -> Result<Self, QuicError> {
        // Ensure crypto provider is installed
        if rustls::crypto::CryptoProvider::get_default().is_none() {
            rustls::crypto::ring::default_provider()
                .install_default()
                .map_err(|_| QuicError::Config("Failed to install default crypto provider".to_string()))?;
        }
        
        // Create insecure client config
        let crypto = rustls::ClientConfig::builder()
            .dangerous()
            .with_custom_certificate_verifier(SkipServerVerification::new())
            .with_no_client_auth();
            
        let mut config = quinn::ClientConfig::new(Arc::new(
            quinn::crypto::rustls::QuicClientConfig::try_from(crypto)
                .map_err(|e| QuicError::Config(format!("Failed to create QUIC client config: {:?}", e)))?
        ));
        
        // Configure transport parameters for better performance
        let mut transport = quinn::TransportConfig::default();
        transport.max_concurrent_bidi_streams(100u32.into());
        transport.max_concurrent_uni_streams(100u32.into());
        config.transport_config(Arc::new(transport));
        
        // Create endpoint with default socket
        let mut endpoint = quinn::Endpoint::client(SocketAddr::new(Ipv4Addr::UNSPECIFIED.into(), 0))
            .map_err(|e| QuicError::Endpoint(format!("Failed to create client endpoint: {:?}", e)))?;
            
        endpoint.set_default_client_config(config);
        
        Ok(Self { inner: endpoint })
    }
    
    /// Connect to a server
    pub async fn connect(&self, addr: String, server_name: String) -> Result<QuicConnection, QuicError> {
        let addr: SocketAddr = addr.parse()
            .map_err(|e| QuicError::Connection(format!("Invalid address: {:?}", e)))?;
        
        let connecting = self.inner.connect(addr, &server_name)
            .map_err(|e| QuicError::Connection(format!("Failed to initiate connection: {:?}", e)))?;
        
        let connection = connecting.await
            .map_err(|e| QuicError::Connection(format!("Failed to establish connection: {:?}", e)))?;
        
        Ok(QuicConnection::new(connection))
    }
    
    /// Get a reference to the inner Quinn endpoint
    pub(crate) fn inner(&self) -> &quinn::Endpoint {
        &self.inner
    }
}

/// Skip server certificate verification for testing purposes
#[derive(Debug)]
struct SkipServerVerification;

impl SkipServerVerification {
    fn new() -> Arc<Self> {
        Arc::new(Self)
    }
}

impl rustls::client::danger::ServerCertVerifier for SkipServerVerification {
    fn verify_server_cert(
        &self,
        _end_entity: &rustls::pki_types::CertificateDer<'_>,
        _intermediates: &[rustls::pki_types::CertificateDer<'_>],
        _server_name: &rustls::pki_types::ServerName<'_>,
        _ocsp_response: &[u8],
        _now: rustls::pki_types::UnixTime,
    ) -> Result<rustls::client::danger::ServerCertVerified, rustls::Error> {
        Ok(rustls::client::danger::ServerCertVerified::assertion())
    }

    fn verify_tls12_signature(
        &self,
        _message: &[u8],
        _cert: &rustls::pki_types::CertificateDer<'_>,
        _dss: &rustls::DigitallySignedStruct,
    ) -> Result<rustls::client::danger::HandshakeSignatureValid, rustls::Error> {
        Ok(rustls::client::danger::HandshakeSignatureValid::assertion())
    }

    fn verify_tls13_signature(
        &self,
        _message: &[u8],
        _cert: &rustls::pki_types::CertificateDer<'_>,
        _dss: &rustls::DigitallySignedStruct,
    ) -> Result<rustls::client::danger::HandshakeSignatureValid, rustls::Error> {
        Ok(rustls::client::danger::HandshakeSignatureValid::assertion())
    }

    fn supported_verify_schemes(&self) -> Vec<rustls::SignatureScheme> {
        vec![
            rustls::SignatureScheme::RSA_PKCS1_SHA1,
            rustls::SignatureScheme::ECDSA_SHA1_Legacy,
            rustls::SignatureScheme::RSA_PKCS1_SHA256,
            rustls::SignatureScheme::ECDSA_NISTP256_SHA256,
            rustls::SignatureScheme::RSA_PKCS1_SHA384,
            rustls::SignatureScheme::ECDSA_NISTP384_SHA384,
            rustls::SignatureScheme::RSA_PKCS1_SHA512,
            rustls::SignatureScheme::ECDSA_NISTP521_SHA512,
            rustls::SignatureScheme::RSA_PSS_SHA256,
            rustls::SignatureScheme::RSA_PSS_SHA384,
            rustls::SignatureScheme::RSA_PSS_SHA512,
            rustls::SignatureScheme::ED25519,
            rustls::SignatureScheme::ED448,
        ]
    }
} 