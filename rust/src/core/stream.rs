//! Core Stream API - Direct Quinn stream wrapper

use flutter_rust_bridge::frb;
use crate::errors::{QuicWriteException, QuicReadException, QuicReadToEndException};

#[frb(opaque)]
pub struct QuicSendStream {
    inner: quinn::SendStream,
}

impl QuicSendStream {
    /// Create a new QuicSendStream wrapping a Quinn send stream
    pub fn new(stream: quinn::SendStream) -> Self {
        Self { inner: stream }
    }
    
    /// Write data to the stream
    /// 
    /// Returns the number of bytes written.
    /// 
    /// # Arguments
    /// 
    /// * `data` - The bytes to write to the stream
    /// 
    /// # Returns
    /// 
    /// The number of bytes actually written. This may be less than the length
    /// of `data` if the stream's send buffer is full.
    /// 
    /// # Errors
    /// 
    /// Returns a `QuicWriteException` if the stream has been stopped by the peer
    /// or the connection has been lost.
    pub async fn write(&mut self, data: Vec<u8>) -> Result<usize, QuicWriteException> {
        match self.inner.write(&data).await {
            Ok(bytes_written) => Ok(bytes_written),
            Err(write_error) => Err(QuicWriteException::from(write_error)),
        }
    }
    
    /// Write all data to the stream
    /// 
    /// Ensures that all data is written to the stream or an error is returned.
    /// Unlike `write()`, this method will continue writing until all data is sent
    /// or an error occurs.
    /// 
    /// # Arguments
    /// 
    /// * `data` - The bytes to write to the stream
    /// 
    /// # Errors
    /// 
    /// Returns a `QuicWriteException` if the stream has been stopped by the peer
    /// or the connection has been lost.
    pub async fn write_all(&mut self, data: Vec<u8>) -> Result<(), QuicWriteException> {
        match self.inner.write_all(&data).await {
            Ok(()) => Ok(()),
            Err(write_error) => Err(QuicWriteException::from(write_error)),
        }
    }
    
    /// Finish the stream
    /// 
    /// Signals that no more data will be sent on this stream. This will cause
    /// the receiving end to receive an end-of-stream signal after all
    /// previously written data has been delivered.
    /// 
    /// # Errors
    /// 
    /// Returns a `QuicWriteException` if the stream has already been finished
    /// or the connection has been lost.
    pub fn finish(&mut self) -> Result<(), QuicWriteException> {
        match self.inner.finish() {
            Ok(()) => Ok(()),
            Err(write_error) => Err(QuicWriteException::from(write_error)),
        }
    }
    
    /// Get a reference to the inner Quinn send stream
    pub(crate) fn inner(&self) -> &quinn::SendStream {
        &self.inner
    }
    
    /// Get a mutable reference to the inner Quinn send stream
    pub(crate) fn inner_mut(&mut self) -> &mut quinn::SendStream {
        &mut self.inner
    }
}

#[frb(opaque)]
pub struct QuicRecvStream {
    inner: quinn::RecvStream,
}

impl QuicRecvStream {
    /// Create a new QuicRecvStream wrapping a Quinn receive stream
    pub fn new(stream: quinn::RecvStream) -> Self {
        Self { inner: stream }
    }
    
    /// Read data from the stream
    /// 
    /// Attempts to read data from the stream into a buffer.
    /// 
    /// # Arguments
    /// 
    /// * `max_length` - Maximum number of bytes to read
    /// 
    /// # Returns
    /// 
    /// Returns `Some(Vec<u8>)` with the data read, or `None` if the stream
    /// has been finished by the peer. The returned data may be less than
    /// `max_length` bytes.
    /// 
    /// # Errors
    /// 
    /// Returns a `QuicReadException` if the stream has been reset by the peer,
    /// the connection has been lost, or other read errors occur.
    pub async fn read(&mut self, max_length: usize) -> Result<Option<Vec<u8>>, QuicReadException> {
        let mut buf = vec![0u8; max_length];
        match self.inner.read(&mut buf).await {
            Ok(Some(bytes_read)) => {
                buf.truncate(bytes_read);
                Ok(Some(buf))
            }
            Ok(None) => Ok(None), // Stream finished
            Err(read_error) => Err(QuicReadException::from(read_error)),
        }
    }
    
    /// Read all remaining data from the stream
    /// 
    /// Reads data until the stream is finished or the size limit is reached.
    /// This method uses unordered reads internally for efficiency and is not
    /// cancel-safe.
    /// 
    /// # Arguments
    /// 
    /// * `size_limit` - Maximum number of bytes to read to prevent memory exhaustion
    /// 
    /// # Returns
    /// 
    /// Returns all remaining data from the stream as a Vec<u8>.
    /// 
    /// # Errors
    /// 
    /// Returns a `QuicReadToEndException::TooLong` if the stream data exceeds
    /// the size limit, or `QuicReadToEndException::Read` for other read errors.
    pub async fn read_to_end(&mut self, size_limit: usize) -> Result<Vec<u8>, QuicReadToEndException> {
        match self.inner.read_to_end(size_limit).await {
            Ok(data) => Ok(data),
            Err(read_to_end_error) => Err(QuicReadToEndException::from(read_to_end_error)),
        }
    }
    
    /// Get a reference to the inner Quinn receive stream
    pub(crate) fn inner(&self) -> &quinn::RecvStream {
        &self.inner
    }
    
    /// Get a mutable reference to the inner Quinn receive stream
    pub(crate) fn inner_mut(&mut self) -> &mut quinn::RecvStream {
        &mut self.inner
    }
}

// Legacy QuicStream for compatibility
#[frb(opaque)]
pub struct QuicStream {
    // This is kept for backward compatibility but not used in new API
    _unused: (),
} 