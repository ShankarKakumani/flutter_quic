//! Common types and data structures

use flutter_rust_bridge::frb;

/// QUIC connection ID
#[frb]
pub struct ConnectionId {
    pub bytes: Vec<u8>,
}

/// Network address information
#[frb]
pub struct SocketAddress {
    pub ip: String,
    pub port: u16,
}

/// Stream direction enumeration
#[frb]
pub enum StreamDirection {
    Bidirectional,
    Unidirectional,
} 