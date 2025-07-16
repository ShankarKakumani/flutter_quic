# Technical Architecture - Flutter QUIC Bridge

## Project Overview
Flutter package wrapping Quinn Rust QUIC library using flutter_rust_bridge. Complete 1:1 Quinn API mapping with zero custom protocol logic.

## Project Structure

### Root Directory
```
flutter_quic/
├── lib/                       # Flutter/Dart code
├── rust/                      # Rust crate
├── example/                   # Example applications
├── test/                      # Dart tests
├── integration_test/          # Integration tests
├── pubspec.yaml              # Flutter package config
├── Cargo.toml                # Rust workspace config
└── build.rs                  # Build script
```

### Rust Crate Structure
```
rust/
├── Cargo.toml                # Rust dependencies
├── build.rs                  # flutter_rust_bridge codegen
├── src/
│   ├── lib.rs                # Main entry + FRB exports
│   ├── models/               # Data structures & enums
│   │   ├── mod.rs
│   │   ├── core_models.rs    # Direct Quinn type mappings
│   │   ├── convenience_models.rs # Convenience API models
│   │   ├── config_models.rs  # Configuration wrappers
│   │   └── enums.rs          # All enums (Quinn mappings)
│   ├── core/                 # Core API (Priority 1)
│   │   ├── mod.rs
│   │   ├── endpoint.rs       # QuicEndpoint wrapper
│   │   ├── connection.rs     # QuicConnection wrapper
│   │   ├── streams.rs        # QuicSendStream, QuicRecvStream
│   │   └── config.rs         # Configuration builders
│   ├── convenience/          # Convenience API (Priority 2)
│   │   ├── mod.rs
│   │   └── client.rs         # QuicClient
│   ├── errors/               # Error handling
│   │   ├── mod.rs
│   │   └── mappings.rs       # Quinn → Custom error conversion
│   └── utils/                # Utilities
│       ├── mod.rs
│       └── conversions.rs    # Type conversions
```

### Flutter/Dart Structure
```
lib/
├── flutter_quic.dart         # Main public API export
├── src/
│   ├── models/               # Data classes (auto-generated)
│   │   ├── core_models.dart  # Core API models
│   │   ├── convenience_models.dart # Convenience API models
│   │   ├── config_models.dart # Configuration classes
│   │   └── enums.dart        # All enums
│   ├── core/                 # Core API Dart bindings
│   │   ├── endpoint.dart     # QuicEndpoint
│   │   ├── connection.dart   # QuicConnection
│   │   ├── streams.dart      # QuicSendStream, QuicRecvStream
│   │   └── config.dart       # Configuration
│   ├── convenience/          # Convenience API
│   │   ├── quic_client.dart  # QuicClient
│   │   └── quic_config.dart  # QuicConfig
│   ├── errors/               # Exception definitions
│   │   ├── quic_exceptions.dart
│   │   └── error_mappings.dart
│   └── generated/            # flutter_rust_bridge generated
│       └── bridge_generated.dart
```

## Key Dependencies

### Rust Dependencies
- **quinn = "0.11"** - Core QUIC library
- **flutter_rust_bridge = "2.11"** - Rust-Dart bridge
- **tokio** - Async runtime for Quinn
- **rustls** - TLS implementation
- **thiserror** - Error handling

## Memory Management

### Rust Ownership Model
```rust
// All Quinn objects owned by Rust
#[frb(opaque)]
pub struct QuicEndpoint(quinn::Endpoint);

#[frb(opaque)]
pub struct QuicConnection(quinn::Connection);

// Automatic cleanup via Drop
impl Drop for QuicConnection {
    fn drop(&mut self) {
        // Quinn handles cleanup automatically
    }
}
```

### Flutter Handle Management
```dart
// Flutter holds opaque handles
class QuicConnection {
  // Managed by flutter_rust_bridge
  // Automatic cleanup when Dart object is GC'd
}
```

## Threading & Async Model

### Rust Async Runtime
```rust
// Tokio runtime for Quinn operations
#[tokio::main]
async fn main() {
    // Quinn operations run on Tokio
}

// Direct async bridging
pub async fn connect(&self, addr: String, server_name: String) -> Result<QuicConnection, String> {
    let connection = self.0.connect(addr.parse()?, &server_name)?.await?;
    Ok(QuicConnection(connection))
}
```

### Flutter Future Integration
```dart
// Rust Future<T> → Dart Future<T>
Future<QuicConnection> connect(String addr, String serverName) async {
    // Direct async bridging - no manual threading
}
```

## API Architecture

### Core API (Priority 1)
- **Direct Quinn mapping**: Every Quinn method exposed
- **Opaque objects**: Rust owns all Quinn types
- **Full functionality**: Complete QUIC protocol support
- **Performance**: <5% overhead vs native Quinn

### Convenience API (Priority 2)
- **Built on Core API**: Uses Core API internally
- **Simple interface**: Dio-style HTTP-like API
- **Connection pooling**: Automatic connection management
- **80% use cases**: Covers common scenarios

## Type System

### Quinn → Rust → Dart Mapping
```rust
// Quinn type → Rust wrapper → Dart class
quinn::ConnectionStats → QuicConnectionStats → QuicConnectionStats (Dart)
quinn::StreamId → QuicStreamId → QuicStreamId (Dart)
quinn::Side → QuicSide → QuicSide (Dart)
```

### Error Propagation
```rust
// Quinn errors → Custom errors → Dart exceptions
quinn::ConnectionError → QuicConnectionError → QuicConnectionException (Dart)
quinn::WriteError → QuicWriteError → QuicWriteException (Dart)
```

## Platform Support

### Target Platforms
- **iOS**: 12.0+
- **Android**: API 21+
- **Future**: Windows, macOS, Linux

### Build Targets
- **iOS**: aarch64-apple-ios, x86_64-apple-ios-sim
- **Android**: aarch64-linux-android, armv7-linux-androideabi, x86_64-linux-android

## Testing Strategy
- **Unit tests**: Individual module testing
- **Integration tests**: Real QUIC connections
- **Platform tests**: iOS/Android specific
- **Performance tests**: Benchmarking vs native

## Security & Safety

### Certificate Handling
- **Native root certificates**: System certificate store
- **Custom certificates**: Application-provided certificates
- **Certificate validation**: Full chain validation

### Memory Safety
- **Rust ownership**: No memory leaks
- **Safe FFI**: flutter_rust_bridge handles safety
- **Resource cleanup**: Automatic via Drop traits

---

**Architecture Status**: Ready for Phase 1 implementation  
**Next Step**: Error handling strategy design 