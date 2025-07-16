/// A Flutter plugin for QUIC protocol support using Quinn Rust library.
///
/// This library provides a complete wrapper around the Quinn QUIC implementation,
/// exposing both Core API (direct 1:1 Quinn mapping) and Convenience API
/// (simplified wrappers for common use cases).
///
/// ## Core API
/// Direct mapping to Quinn's API surface:
/// - QuicEndpoint: QUIC endpoint management
/// - QuicConnection: Connection handling
/// - QuicSendStream/QuicRecvStream: Stream operations
///
/// ## Convenience API
/// Simplified wrappers built on Core API:
/// - QuicClient: High-level client operations
/// - Connection pooling and automatic retry logic
library;
// Flutter QUIC package exports

// Export the rust bridge API
export 'src/rust/api/bridge.dart';

// Export library initialization
export 'src/rust/frb_generated.dart' show RustLib;

// Export core types
export 'src/rust/core/endpoint.dart';
export 'src/rust/core/connection.dart';
export 'src/rust/core/stream.dart';

// Export convenience types
export 'src/rust/convenience/client.dart';

// Export error types
export 'src/rust/errors.dart';
