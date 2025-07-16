//! Core Connection API - Direct Quinn connection wrapper

use flutter_rust_bridge::frb;
use crate::core::stream::{QuicSendStream, QuicRecvStream};
use crate::errors::{QuicError, QuicDatagramException};
use std::net::{SocketAddr, IpAddr};
use std::time::Duration;

#[derive(Debug)]
#[frb(opaque)]
pub struct QuicConnection {
    inner: quinn::Connection,
}

impl QuicConnection {
    /// Create a new QuicConnection wrapping a Quinn connection
    pub fn new(connection: quinn::Connection) -> Self {
        Self { inner: connection }
    }
    
    /// Open a bidirectional stream
    pub async fn open_bi(&self) -> Result<(QuicSendStream, QuicRecvStream), QuicError> {
        let (send_stream, recv_stream) = self.inner
            .open_bi()
            .await
            .map_err(|e| QuicError::Connection(format!("Failed to open bidirectional stream: {:?}", e)))?;
        
        Ok((QuicSendStream::new(send_stream), QuicRecvStream::new(recv_stream)))
    }
    
    /// Open a unidirectional stream for sending
    pub async fn open_uni(&self) -> Result<QuicSendStream, QuicError> {
        let send_stream = self.inner
            .open_uni()
            .await
            .map_err(|e| QuicError::Connection(format!("Failed to open unidirectional stream: {:?}", e)))?;
        
        Ok(QuicSendStream::new(send_stream))
    }

    // Datagram operations
    
    /// Send an unreliable datagram
    pub fn send_datagram(&self, data: Vec<u8>) -> Result<(), QuicDatagramException> {
        match self.inner.send_datagram(data.into()) {
            Ok(()) => Ok(()),
            Err(error) => {
                // If the error is TooLarge, try to get the actual max size
                if let quinn::SendDatagramError::TooLarge = error {
                    let max_size = self.inner.max_datagram_size().unwrap_or(0);
                    Err(QuicDatagramException::TooLarge { max_size })
                } else {
                    Err(QuicDatagramException::from(error))
                }
            }
        }
    }

    /// Send a datagram, waiting for buffer space
    pub async fn send_datagram_wait(&self, data: Vec<u8>) -> Result<(), QuicDatagramException> {
        self.inner
            .send_datagram_wait(data.into())
            .await
            .map_err(QuicDatagramException::from)
    }

    /// Read a datagram from the connection
    pub async fn read_datagram(&self) -> Option<Vec<u8>> {
        match self.inner.read_datagram().await {
            Ok(datagram) => Some(datagram.to_vec()),
            Err(_) => None,
        }
    }

    /// Get the space available in the datagram send buffer
    pub fn datagram_send_buffer_space(&self) -> usize {
        self.inner.datagram_send_buffer_space()
    }

    /// Get the maximum datagram size
    pub fn max_datagram_size(&self) -> Option<usize> {
        self.inner.max_datagram_size()
    }

    // Connection Info operations

    /// Get the remote address of the peer
    pub fn remote_address(&self) -> SocketAddr {
        self.inner.remote_address()
    }

    /// Get the local IP address used for this connection
    pub fn local_ip(&self) -> Option<IpAddr> {
        self.inner.local_ip()
    }

    /// Get the current round-trip time estimate
    pub fn rtt(&self) -> Duration {
        self.inner.rtt()
    }

    /// Get a stable identifier for this connection
    pub fn stable_id(&self) -> usize {
        self.inner.stable_id()
    }

    /// Get the reason the connection was closed, if any
    pub fn close_reason(&self) -> Option<String> {
        self.inner.close_reason().map(|error| format!("{:?}", error))
    }

    /// Get connection statistics
    pub fn stats(&self) -> QuicConnectionStats {
        let quinn_stats = self.inner.stats();
        QuicConnectionStats::from(quinn_stats)
    }
    
    /// Get a reference to the inner Quinn connection
    pub(crate) fn inner(&self) -> &quinn::Connection {
        &self.inner
    }
}

/// Connection statistics from Quinn
#[derive(Debug, Clone)]
pub struct QuicConnectionStats {
    pub path: QuicPathStats,
    pub frame_tx: QuicFrameStats,
    pub frame_rx: QuicFrameStats,
    pub udp_tx: QuicUdpStats,
    pub udp_rx: QuicUdpStats,
}

/// Path-specific statistics
#[derive(Debug, Clone)]
pub struct QuicPathStats {
    pub rtt_millis: u64,
    pub cwnd: u64,
    pub lost_packets: u64,
    pub lost_bytes: u64,
    pub sent_packets: u64,
    pub congestion_events: u64,
}

/// Frame transmission/reception statistics
#[derive(Debug, Clone)]
pub struct QuicFrameStats {
    pub acks: u64,
    pub crypto: u64,
    pub connection_close: u64,
    pub data_blocked: u64,
    pub datagram: u64,
    pub handshake_done: u64,
    pub max_data: u64,
    pub max_stream_data: u64,
    pub max_streams_bidi: u64,
    pub max_streams_uni: u64,
    pub new_connection_id: u64,
    pub new_token: u64,
    pub path_challenge: u64,
    pub path_response: u64,
    pub ping: u64,
    pub reset_stream: u64,
    pub retire_connection_id: u64,
    pub stream: u64,
    pub stream_data_blocked: u64,
    pub streams_blocked_bidi: u64,
    pub streams_blocked_uni: u64,
    pub stop_sending: u64,
}

/// UDP-level statistics
#[derive(Debug, Clone)]
pub struct QuicUdpStats {
    pub datagrams: u64,
    pub bytes: u64,
    pub ios: u64,
}

impl From<quinn::ConnectionStats> for QuicConnectionStats {
    fn from(stats: quinn::ConnectionStats) -> Self {
        Self {
            path: QuicPathStats::from(stats.path),
            frame_tx: QuicFrameStats::from(stats.frame_tx),
            frame_rx: QuicFrameStats::from(stats.frame_rx),
            udp_tx: QuicUdpStats::from(stats.udp_tx),
            udp_rx: QuicUdpStats::from(stats.udp_rx),
        }
    }
}

impl From<quinn::PathStats> for QuicPathStats {
    fn from(stats: quinn::PathStats) -> Self {
        Self {
            rtt_millis: stats.rtt.as_millis() as u64,
            cwnd: stats.cwnd,
            lost_packets: stats.lost_packets,
            lost_bytes: stats.lost_bytes,
            sent_packets: stats.sent_packets,
            congestion_events: stats.congestion_events,
        }
    }
}

impl From<quinn::FrameStats> for QuicFrameStats {
    fn from(stats: quinn::FrameStats) -> Self {
        Self {
            acks: stats.acks,
            crypto: stats.crypto,
            connection_close: stats.connection_close,
            data_blocked: stats.data_blocked,
            datagram: stats.datagram,
            handshake_done: stats.handshake_done as u64, // Convert u8 to u64
            max_data: stats.max_data,
            max_stream_data: stats.max_stream_data,
            max_streams_bidi: stats.max_streams_bidi,
            max_streams_uni: stats.max_streams_uni,
            new_connection_id: stats.new_connection_id,
            new_token: stats.new_token,
            path_challenge: stats.path_challenge,
            path_response: stats.path_response,
            ping: stats.ping,
            reset_stream: stats.reset_stream,
            retire_connection_id: stats.retire_connection_id,
            stream: stats.stream,
            stream_data_blocked: stats.stream_data_blocked,
            streams_blocked_bidi: stats.streams_blocked_bidi,
            streams_blocked_uni: stats.streams_blocked_uni,
            stop_sending: stats.stop_sending,
        }
    }
}

impl From<quinn::UdpStats> for QuicUdpStats {
    fn from(stats: quinn::UdpStats) -> Self {
        Self {
            datagrams: stats.datagrams,
            bytes: stats.bytes,
            ios: stats.ios, // Use ios instead of transmits
        }
    }
} 