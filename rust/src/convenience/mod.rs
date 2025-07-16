//! Convenience API - Simple, high-level interface
//! 
//! This module provides an easy-to-use API built on top of the Core API,
//! with features like connection pooling, automatic retries, and simplified configuration.

pub mod client;
pub mod server;
pub mod pool;

pub use client::{QuicClient, QuicClientConfig}; 