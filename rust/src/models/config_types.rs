//! Configuration data structures

use flutter_rust_bridge::frb;

/// Transport configuration parameters
#[frb]
pub struct TransportConfig {
    pub max_idle_timeout: Option<u64>,
    pub max_uni_streams: Option<u32>,
    pub max_bi_streams: Option<u32>,
    pub max_data: Option<u64>,
}

/// Endpoint configuration
#[frb]
pub struct EndpointConfig {
    pub transport: TransportConfig,
    pub alpn_protocols: Vec<String>,
} 