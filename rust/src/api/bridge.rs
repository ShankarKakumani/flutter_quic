#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

// Core API exposure functions to ensure flutter_rust_bridge discovers our types
use crate::core::{QuicEndpoint, QuicConnection, QuicSendStream, QuicRecvStream};
use crate::core::{QuicConnectionStats, QuicPathStats, QuicFrameStats, QuicUdpStats};
use crate::core::{QuicServerConfig, QuicTransportConfig, QuicEndpointConfig};
use crate::convenience::{QuicClient, QuicClientConfig};
use crate::errors::{QuicError, QuicWriteException, QuicReadException, QuicReadToEndException, QuicDatagramException};



/// Create a new QUIC client endpoint
pub fn create_client_endpoint() -> Result<QuicEndpoint, QuicError> {
    let rt = tokio::runtime::Runtime::new()
        .map_err(|e| QuicError::Endpoint(format!("Failed to create runtime: {:?}", e)))?;
    
    rt.block_on(async {
        QuicEndpoint::client()
    })
}

/// Create a new QUIC server endpoint
pub fn create_server_endpoint(config: QuicServerConfig, addr: String) -> Result<QuicEndpoint, QuicError> {
    QuicEndpoint::server(config, addr)
}

/// Write data to a QUIC send stream
/// This exposes the QuicSendStream.write() method to flutter_rust_bridge
pub async fn send_stream_write(
    mut stream: QuicSendStream,
    data: Vec<u8>,
) -> Result<(QuicSendStream, usize), QuicWriteException> {
    let bytes_written = stream.write(data).await?;
    Ok((stream, bytes_written))
}

/// Write all data to a QUIC send stream
/// This exposes the QuicSendStream.write_all() method to flutter_rust_bridge
pub async fn send_stream_write_all(
    mut stream: QuicSendStream,
    data: Vec<u8>,
) -> Result<QuicSendStream, QuicWriteException> {
    stream.write_all(data).await?;
    Ok(stream)
}

/// Finish a QUIC send stream
/// This exposes the QuicSendStream.finish() method to flutter_rust_bridge
pub fn send_stream_finish(
    mut stream: QuicSendStream,
) -> Result<QuicSendStream, QuicWriteException> {
    stream.finish()?;
    Ok(stream)
}

/// Read data from a QUIC recv stream
/// This exposes the QuicRecvStream.read() method to flutter_rust_bridge
pub async fn recv_stream_read(
    mut stream: QuicRecvStream,
    max_length: usize,
) -> Result<(QuicRecvStream, Option<Vec<u8>>), QuicReadException> {
    let data = stream.read(max_length).await?;
    Ok((stream, data))
}

/// Read all remaining data from a QUIC recv stream
/// This exposes the QuicRecvStream.read_to_end() method to flutter_rust_bridge
pub async fn recv_stream_read_to_end(
    mut stream: QuicRecvStream,
    max_length: usize,
) -> Result<(QuicRecvStream, Vec<u8>), QuicReadToEndException> {
    let data = stream.read_to_end(max_length).await?;
    Ok((stream, data))
}

/// Open a bidirectional stream on a QUIC connection
/// This exposes the QuicConnection.open_bi() method to flutter_rust_bridge
pub async fn connection_open_bi(
    connection: QuicConnection,
) -> Result<(QuicConnection, QuicSendStream, QuicRecvStream), QuicError> {
    let (send_stream, recv_stream) = connection.open_bi().await?;
    Ok((connection, send_stream, recv_stream))
}

/// Open a unidirectional stream on a QUIC connection
/// This exposes the QuicConnection.open_uni() method to flutter_rust_bridge
pub async fn connection_open_uni(
    connection: QuicConnection,
) -> Result<(QuicConnection, QuicSendStream), QuicError> {
    let send_stream = connection.open_uni().await?;
    Ok((connection, send_stream))
}

/// Connect to a server using a QUIC endpoint
/// This exposes the QuicEndpoint.connect() method to flutter_rust_bridge
pub async fn endpoint_connect(
    endpoint: QuicEndpoint,
    addr: String,
    server_name: String,
) -> Result<(QuicEndpoint, QuicConnection), QuicError> {
    let connection = endpoint.connect(addr, server_name).await?;
    Ok((endpoint, connection))
}

/// Send a datagram on a QUIC connection
/// This exposes the QuicConnection.send_datagram() method to flutter_rust_bridge
pub fn connection_send_datagram(
    connection: QuicConnection,
    data: Vec<u8>,
) -> Result<QuicConnection, QuicDatagramException> {
    connection.send_datagram(data)?;
    Ok(connection)
}

/// Send a datagram with backpressure on a QUIC connection
/// This exposes the QuicConnection.send_datagram_wait() method to flutter_rust_bridge
pub async fn connection_send_datagram_wait(
    connection: QuicConnection,
    data: Vec<u8>,
) -> Result<QuicConnection, QuicDatagramException> {
    connection.send_datagram_wait(data).await?;
    Ok(connection)
}

/// Read a datagram from a QUIC connection
/// This exposes the QuicConnection.read_datagram() method to flutter_rust_bridge
pub async fn connection_read_datagram(
    connection: QuicConnection,
) -> (QuicConnection, Option<Vec<u8>>) {
    let data = connection.read_datagram().await;
    (connection, data)
}

/// Get datagram send buffer space
/// This exposes the QuicConnection.datagram_send_buffer_space() method to flutter_rust_bridge
pub fn connection_datagram_send_buffer_space(
    connection: QuicConnection,
) -> (QuicConnection, usize) {
    let space = connection.datagram_send_buffer_space();
    (connection, space)
}

/// Get maximum datagram size
/// This exposes the QuicConnection.max_datagram_size() method to flutter_rust_bridge
pub fn connection_max_datagram_size(
    connection: QuicConnection,
) -> (QuicConnection, Option<usize>) {
    let max_size = connection.max_datagram_size();
    (connection, max_size)
}

// Connection Info bridge functions

/// Get the remote address of a QUIC connection
/// This exposes the QuicConnection.remote_address() method to flutter_rust_bridge
pub fn connection_remote_address(
    connection: QuicConnection,
) -> (QuicConnection, crate::models::types::SocketAddress) {
    let addr = connection.remote_address();
    let socket_addr = crate::models::types::SocketAddress {
        ip: addr.ip().to_string(),
        port: addr.port(),
    };
    (connection, socket_addr)
}

/// Get the local IP address of a QUIC connection
/// This exposes the QuicConnection.local_ip() method to flutter_rust_bridge
pub fn connection_local_ip(
    connection: QuicConnection,
) -> (QuicConnection, Option<String>) {
    let ip = connection.local_ip();
    (connection, ip.map(|ip| ip.to_string()))
}

/// Get the RTT of a QUIC connection in milliseconds
/// This exposes the QuicConnection.rtt() method to flutter_rust_bridge
pub fn connection_rtt_millis(
    connection: QuicConnection,
) -> (QuicConnection, u64) {
    let rtt = connection.rtt();
    (connection, rtt.as_millis() as u64)
}

/// Get the stable ID of a QUIC connection
/// This exposes the QuicConnection.stable_id() method to flutter_rust_bridge
pub fn connection_stable_id(
    connection: QuicConnection,
) -> (QuicConnection, usize) {
    let id = connection.stable_id();
    (connection, id)
}

/// Get the close reason of a QUIC connection
/// This exposes the QuicConnection.close_reason() method to flutter_rust_bridge
pub fn connection_close_reason(
    connection: QuicConnection,
) -> (QuicConnection, Option<String>) {
    let reason = connection.close_reason();
    (connection, reason)
}

/// Get the statistics of a QUIC connection
/// This exposes the QuicConnection.stats() method to flutter_rust_bridge
pub fn connection_stats(
    connection: QuicConnection,
) -> (QuicConnection, QuicConnectionStats) {
    let stats = connection.stats();
    (connection, stats)
}

// Configuration builder functions

/// Create a new server config with single certificate
pub fn server_config_with_single_cert(
    cert_chain: Vec<Vec<u8>>,
    key: Vec<u8>,
) -> Result<QuicServerConfig, String> {
    QuicServerConfig::with_single_cert(cert_chain, key)
}

/// Create a new transport config
pub fn transport_config_new() -> QuicTransportConfig {
    QuicTransportConfig::new()
}

/// Create a new endpoint config
pub fn endpoint_config_new() -> QuicEndpointConfig {
    QuicEndpointConfig::new()
}

// Type exposure functions to ensure flutter_rust_bridge discovers our types
pub fn _expose_types_for_frb_generation() {
    let _endpoint: Option<QuicEndpoint> = None;
    let _connection: Option<QuicConnection> = None;
    let _send_stream: Option<QuicSendStream> = None;
    let _recv_stream: Option<QuicRecvStream> = None;
    let _error: Option<QuicError> = None;
    let _write_exception: Option<QuicWriteException> = None;
    let _read_exception: Option<QuicReadException> = None;
    let _read_to_end_exception: Option<QuicReadToEndException> = None;
    let _datagram_exception: Option<QuicDatagramException> = None;
    let _connection_stats: Option<QuicConnectionStats> = None;
    let _path_stats: Option<QuicPathStats> = None;
    let _frame_stats: Option<QuicFrameStats> = None;
    let _udp_stats: Option<QuicUdpStats> = None;
    let _server_config: Option<QuicServerConfig> = None;
    let _transport_config: Option<QuicTransportConfig> = None;
    let _endpoint_config: Option<QuicEndpointConfig> = None;
}

// Legacy expose functions for backwards compatibility with generated code
pub fn _expose_connection_type(connection: QuicConnection) -> QuicConnection {
    connection
}

pub fn _expose_send_stream_type(stream: QuicSendStream) -> QuicSendStream {
    stream
}

pub fn _expose_recv_stream_type(stream: QuicRecvStream) -> QuicRecvStream {
    stream
}

// Convenience API exposure functions

/// Create a new QuicClient with default configuration
pub fn quic_client_create() -> Result<QuicClient, QuicError> {
    let rt = tokio::runtime::Runtime::new()
        .map_err(|e| QuicError::Endpoint(format!("Failed to create runtime: {:?}", e)))?;
    
    rt.block_on(async {
        QuicClient::create()
    })
}

/// Create a new QuicClient with custom configuration
pub fn quic_client_create_with_config(config: QuicClientConfig) -> Result<QuicClient, QuicError> {
    let rt = tokio::runtime::Runtime::new()
        .map_err(|e| QuicError::Endpoint(format!("Failed to create runtime: {:?}", e)))?;
    
    rt.block_on(async {
        QuicClient::create_with_config(config)
    })
}

/// Send data using QuicClient and return response
pub async fn quic_client_send(
    client: QuicClient,
    url: String,
    data: String,
) -> Result<(QuicClient, String), QuicError> {
    let response = client.send(url, data).await?;
    Ok((client, response))
}

/// Send data with timeout using QuicClient
pub async fn quic_client_send_with_timeout(
    client: QuicClient,
    url: String,
    data: String,
) -> Result<(QuicClient, String), QuicError> {
    let response = client.send_with_timeout(url, data).await?;
    Ok((client, response))
}

/// Send a GET request using QuicClient
pub async fn quic_client_get(
    client: QuicClient,
    url: String,
) -> Result<(QuicClient, String), QuicError> {
    let response = client.get(url).await?;
    Ok((client, response))
}

/// Send a POST request using QuicClient
pub async fn quic_client_post(
    client: QuicClient,
    url: String,
    data: String,
) -> Result<(QuicClient, String), QuicError> {
    let response = client.post(url, data).await?;
    Ok((client, response))
}

/// Send a GET request with timeout using QuicClient
pub async fn quic_client_get_with_timeout(
    client: QuicClient,
    url: String,
) -> Result<(QuicClient, String), QuicError> {
    let response = client.get_with_timeout(url).await?;
    Ok((client, response))
}

/// Send a POST request with timeout using QuicClient
pub async fn quic_client_post_with_timeout(
    client: QuicClient,
    url: String,
    data: String,
) -> Result<(QuicClient, String), QuicError> {
    let response = client.post_with_timeout(url, data).await?;
    Ok((client, response))
}

/// Get QuicClient configuration
pub fn quic_client_config(client: QuicClient) -> (QuicClient, QuicClientConfig) {
    let config = client.config();
    (client, config)
}

/// Clear QuicClient connection pool
pub fn quic_client_clear_pool(client: QuicClient) -> QuicClient {
    client.clear_pool();
    client
}

/// Create a new QuicClientConfig with default values
pub fn quic_client_config_new() -> QuicClientConfig {
    QuicClientConfig::default()
}

/// Expose QuicClient and QuicClientConfig types for flutter_rust_bridge
pub fn _expose_quic_client_type(client: QuicClient) -> QuicClient {
    client
}

pub fn _expose_quic_client_config_type(config: QuicClientConfig) -> QuicClientConfig {
    config
}
