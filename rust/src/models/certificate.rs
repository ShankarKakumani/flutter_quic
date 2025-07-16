//! Certificate and TLS related types

use flutter_rust_bridge::frb;

/// Certificate chain for TLS
#[frb]
pub struct CertificateChain {
    pub certificates: Vec<Vec<u8>>,
}

/// Private key for TLS
#[frb]
pub struct PrivateKey {
    pub key_data: Vec<u8>,
} 