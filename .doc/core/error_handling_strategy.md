# Error Handling Strategy

## Core Principle
**Every Quinn error type gets a specific Dart exception** - no generic error handling.

## Error Flow
```
Quinn Error → Rust Custom Error → Dart Exception
```

## Quinn Error Mappings

### 1. Connection Errors
```rust
quinn::ConnectionError → QuicConnectionError → QuicConnectionException
```
- `VersionMismatch` → `versionMismatch`
- `TransportError` → `transportError`
- `ApplicationClosed` → `applicationClosed` (with error code + reason)
- `Reset` → `reset`
- `TimedOut` → `timedOut`
- `LocallyClosed` → `locallyClosed`

### 2. Stream Errors
```rust
quinn::WriteError → QuicWriteError → QuicWriteException
quinn::ReadError → QuicReadError → QuicReadException
```
- `Stopped(code)` → `stopped` (with error code)
- `ConnectionLost` → `connectionLost` (with connection error)
- `UnknownStream` → `unknownStream`
- `ZeroRttRejected` → `zeroRttRejected`

### 3. Connect Errors
```rust
quinn::ConnectError → QuicConnectError → QuicConnectException
```
- `EndpointStopping` → `endpointStopping`
- `TooManyConnections` → `tooManyConnections`
- `InvalidDnsName` → `invalidDnsName`
- `InvalidRemoteAddress` → `invalidRemoteAddress`
- `UnsupportedVersion` → `unsupportedVersion`

### 4. Datagram Errors
```rust
quinn::SendDatagramError → QuicDatagramError → QuicDatagramException
```
- `UnsupportedByPeer` → `unsupportedByPeer`
- `TooLarge` → `tooLarge` (with max size)
- `ConnectionLost` → `connectionLost`

## Implementation Pattern

### Rust Side
```rust
#[derive(Error, Debug)]
pub enum QuicConnectionError {
    #[error("QUIC version mismatch")]
    VersionMismatch,
    #[error("Connection timed out")]
    TimedOut,
    // ... other variants
}

impl From<quinn::ConnectionError> for QuicConnectionError {
    fn from(error: quinn::ConnectionError) -> Self {
        match error {
            quinn::ConnectionError::VersionMismatch => QuicConnectionError::VersionMismatch,
            quinn::ConnectionError::TimedOut => QuicConnectionError::TimedOut,
            // ... other mappings
        }
    }
}
```

### Dart Side
```dart
class QuicConnectionException implements Exception {
  final QuicConnectionErrorType type;
  final String message;
  final int? errorCode;
  final String? reason;
}

enum QuicConnectionErrorType {
  versionMismatch,
  timedOut,
  // ... other variants
}
```

## Error Propagation

### Core API
Direct Quinn error propagation with specific error types.

### Convenience API
Wrapped error handling with context and automatic retry for transient errors.

## Testing
- Error simulation tests for each Quinn error type
- Integration tests with real network failures
- Verify correct Dart exception mapping

---

**Status**: Complete error mapping strategy defined  
**Next**: Phase 1 implementation specification 