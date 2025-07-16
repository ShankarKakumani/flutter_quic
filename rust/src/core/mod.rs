//! Core API - Direct 1:1 mapping to Quinn library
//! 
//! This module provides complete access to Quinn's functionality with minimal abstraction.
//! Every public Quinn method is exposed here for maximum flexibility and power.

pub mod endpoint;
pub mod connection;
pub mod stream;
pub mod config;

pub use endpoint::QuicEndpoint;
pub use connection::{QuicConnection, QuicConnectionStats, QuicPathStats, QuicFrameStats, QuicUdpStats};
pub use stream::{QuicSendStream, QuicRecvStream};
pub use config::{QuicServerConfig, QuicTransportConfig, QuicEndpointConfig}; 