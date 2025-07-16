//! Error handling for Flutter QUIC
//! 
//! Specific error types mapped from Quinn errors to provide
//! clear error handling in Dart applications.

use thiserror::Error;

#[derive(Error, Debug)]
pub enum QuicError {
    #[error("Connection error: {0}")]
    Connection(String),
    
    #[error("Endpoint error: {0}")]
    Endpoint(String),
    
    #[error("Stream error: {0}")]
    Stream(String),
    
    #[error("TLS error: {0}")]
    Tls(String),
    
    #[error("Configuration error: {0}")]
    Config(String),
    
    #[error("Network error: {0}")]
    Network(String),
    
    #[error("Write error: {0}")]
    Write(String),
}

/// Write operation errors when sending data on a QUIC stream
#[derive(Error, Debug)]
pub enum QuicWriteException {
    #[error("Stream was stopped by peer with error code {0}")]
    Stopped(u64),
    
    #[error("Connection was lost: {0}")]
    ConnectionLost(String),
}

impl From<quinn::WriteError> for QuicWriteException {
    fn from(error: quinn::WriteError) -> Self {
        match error {
            quinn::WriteError::Stopped(code) => QuicWriteException::Stopped(code.into()),
            quinn::WriteError::ConnectionLost(conn_err) => {
                QuicWriteException::ConnectionLost(format!("{:?}", conn_err))
            }
            quinn::WriteError::ClosedStream => {
                QuicWriteException::ConnectionLost("Stream was closed".to_string())
            }
            quinn::WriteError::ZeroRttRejected => {
                QuicWriteException::ConnectionLost("0-RTT was rejected".to_string())
            }
        }
    }
}

impl From<quinn::ClosedStream> for QuicWriteException {
    fn from(_error: quinn::ClosedStream) -> Self {
        QuicWriteException::ConnectionLost("Stream was already closed".to_string())
    }
}

/// Read operation errors when receiving data from a QUIC stream
#[derive(Error, Debug)]
pub enum QuicReadException {
    #[error("Stream was reset by peer with error code {0}")]
    Reset(u64),
    
    #[error("Connection was lost: {0}")]
    ConnectionLost(String),
    
    #[error("0-RTT was rejected")]
    ZeroRttRejected,
    
    #[error("Stream was closed")]
    ClosedStream,
    
    #[error("Illegal ordered read")]
    IllegalOrderedRead,
}

impl From<quinn::ReadError> for QuicReadException {
    fn from(error: quinn::ReadError) -> Self {
        match error {
            quinn::ReadError::Reset(code) => QuicReadException::Reset(code.into()),
            quinn::ReadError::ConnectionLost(conn_err) => {
                QuicReadException::ConnectionLost(format!("{:?}", conn_err))
            }
            quinn::ReadError::ZeroRttRejected => QuicReadException::ZeroRttRejected,
            quinn::ReadError::ClosedStream => QuicReadException::ClosedStream,
            quinn::ReadError::IllegalOrderedRead => QuicReadException::IllegalOrderedRead,
        }
    }
}

/// Read-to-end operation errors when reading all remaining data from a QUIC stream
#[derive(Error, Debug)]
pub enum QuicReadToEndException {
    #[error("Read error occurred: {0}")]
    Read(#[from] QuicReadException),
    
    #[error("Stream data exceeds size limit")]
    TooLong,
}

impl From<quinn::ReadToEndError> for QuicReadToEndException {
    fn from(error: quinn::ReadToEndError) -> Self {
        match error {
            quinn::ReadToEndError::Read(read_error) => {
                QuicReadToEndException::Read(QuicReadException::from(read_error))
            }
            quinn::ReadToEndError::TooLong => QuicReadToEndException::TooLong,
        }
    }
}

/// Datagram operation errors when sending unreliable datagrams
#[derive(Error, Debug)]
pub enum QuicDatagramException {
    #[error("Datagrams are not supported by the peer")]
    UnsupportedByPeer,
    
    #[error("Datagram is too large (max size: {max_size})")]
    TooLarge { max_size: usize },
    
    #[error("Connection was lost: {0}")]
    ConnectionLost(String),
}

impl From<quinn::SendDatagramError> for QuicDatagramException {
    fn from(error: quinn::SendDatagramError) -> Self {
        match error {
            quinn::SendDatagramError::UnsupportedByPeer => QuicDatagramException::UnsupportedByPeer,
            quinn::SendDatagramError::Disabled => QuicDatagramException::UnsupportedByPeer,
            quinn::SendDatagramError::TooLarge => {
                // We don't have access to the actual max size from Quinn error,
                // so we'll set a reasonable default that the caller can override
                QuicDatagramException::TooLarge { max_size: 0 }
            }
            quinn::SendDatagramError::ConnectionLost(conn_err) => {
                QuicDatagramException::ConnectionLost(format!("{:?}", conn_err))
            }
        }
    }
}

 