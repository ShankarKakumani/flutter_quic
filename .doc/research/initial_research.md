# Quinn Flutter Bridge Implementation Spec

## Overview
Direct 1:1 mapping of Quinn Rust QUIC library to Flutter/Dart using flutter_rust_bridge. No custom protocol logic - just expose Quinn's complete API surface.

## Architecture

### Core Wrapper Pattern
```rust
pub struct QuicEndpoint(Endpoint);
pub struct QuicConnection(Connection);
pub struct QuicSendStream(SendStream);
pub struct QuicRecvStream(RecvStream);

#[flutter_rust_bridge::frb(opaque)]
impl QuicEndpoint {
    // Direct Quinn method mapping
}
```

### Flutter API Surface
```dart
class QuicEndpoint {
  // Opaque Rust object handle
  // Methods mirror Quinn exactly
}
```

## Method Implementation Matrix

### Endpoint Methods (8-10 hours)
```rust
// Creation
Endpoint::client(bind_addr) -> Result<Endpoint, EndpointError>
Endpoint::server(config, bind_addr) -> Result<Endpoint, EndpointError>

// Connection operations
endpoint.connect(addr, server_name) -> Result<Connecting, ConnectError>
endpoint.accept() -> Accept

// Management
endpoint.local_addr() -> Result<SocketAddr, EndpointError>
endpoint.close(error_code, reason) -> ()
endpoint.wait_idle() -> ()
endpoint.stats() -> EndpointStats
endpoint.rebind(socket) -> Result<(), EndpointError>
```

### Connection Methods (10-12 hours)
```rust
// Stream operations
connection.open_bi() -> Result<(SendStream, RecvStream), ConnectionError>
connection.open_uni() -> Result<SendStream, ConnectionError>
connection.accept_bi() -> Result<(SendStream, RecvStream), ConnectionError>
connection.accept_uni() -> Result<RecvStream, ConnectionError>

// Datagram operations
connection.send_datagram(data) -> Result<(), SendDatagramError>
connection.send_datagram_wait(data) -> SendDatagram
connection.read_datagram() -> ReadDatagram
connection.datagram_send_buffer_size() -> usize
connection.max_datagram_size() -> Option<usize>

// Connection info
connection.remote_address() -> SocketAddr
connection.local_ip() -> Option<IpAddr>
connection.stats() -> ConnectionStats
connection.stable_id() -> usize
connection.close_reason() -> Option<ConnectionError>

// Connection control
connection.close(error_code, reason) -> ()
connection.closed() -> Future<ConnectionError>
```

### SendStream Methods (6-8 hours)
```rust
// Writing
send_stream.write(data) -> Result<usize, WriteError>
send_stream.write_all(data) -> Result<(), WriteError>
send_stream.write_chunk(chunk) -> Result<Written, WriteError>
send_stream.write_chunks(chunks) -> Result<Written, WriteError>

// Flow control
send_stream.finish() -> Result<(), WriteError>
send_stream.reset(error_code) -> Result<(), WriteError>
send_stream.stopped() -> Result<Option<VarInt>, StoppedError>
send_stream.id() -> StreamId
send_stream.max_stream_data() -> u64
send_stream.stream_data_sent() -> u64
```

### RecvStream Methods (6-8 hours)
```rust
// Reading
recv_stream.read(buf) -> Result<Option<usize>, ReadError>
recv_stream.read_exact(buf) -> Result<(), ReadExactError>
recv_stream.read_to_end(max_size) -> Result<Vec<u8>, ReadToEndError>
recv_stream.read_chunk(max_size, ordered) -> Result<Option<Chunk>, ReadError>
recv_stream.read_chunks(max_size) -> Result<Chunks, ReadError>

// Stream control
recv_stream.stop(error_code) -> Result<(), ReadError>
recv_stream.id() -> StreamId
recv_stream.received_reset() -> Result<Option<VarInt>, ResetError>
```

### Configuration & Stats (4-6 hours)
```rust
// Stats structs (read-only exposure)
ConnectionStats
EndpointStats
PathStats
UdpStats
FrameStats

// Configuration structs
ClientConfig
ServerConfig
TransportConfig
EndpointConfig
```

## Implementation Strategy

### Phase 1: Core Connectivity (Day 1-2)
- Endpoint creation/management
- Basic connection establishment
- Simple send/receive on streams
- Basic error handling

### Phase 2: Complete API Surface (Day 3-4)
- All stream operations
- Datagram support
- Stats and introspection
- Configuration options

### Phase 3: Polish & Testing (Day 5-6)
- Error handling consistency
- Memory leak testing
- Device testing (iOS/Android)
- Documentation and examples

## Technical Considerations

### Memory Management
- Use `#[frb(opaque)]` for automatic lifecycle management
- Rust owns all objects, Flutter holds opaque handles
- No manual reference counting needed

### Async Bridging
- Rust `Future<Result<T, E>>` → Dart `Future<T>` (throws on error)
- Rust `Stream<T>` → Dart `Stream<T>`
- flutter_rust_bridge handles async translation

### Error Handling
- Map all Quinn error types to Dart exceptions
- Preserve error context and codes
- Consistent error reporting across API

### Type Translation
- `Vec<u8>` ↔ `Uint8List`
- `String` ↔ `String`
- Custom structs → Dart classes
- Enums → Dart enums

## Deliverables

1. **Rust crate** with complete Quinn API wrapper
2. **Flutter package** with Dart bindings
3. **Example apps** demonstrating usage
4. **Documentation** covering all methods
5. **Test suite** for core functionality

## Time Estimates

| Component | Time |
|-----------|------|
| Endpoint API | 8-10 hours |
| Connection API | 10-12 hours |
| Stream APIs | 12-16 hours |
| Stats/Config | 4-6 hours |
| Testing | 8-10 hours |
| **Total** | **42-54 hours** |

## Quinn Features Included

✅ **All Quinn core features:**
- Connection establishment & management
- Stream multiplexing (bi/unidirectional)
- Datagram support
- 0-RTT connection resumption
- Connection migration
- Congestion control
- Certificate validation
- Flow control & backpressure

❌ **Not included (separate projects):**
- HTTP/3 (use `h3` crate)
- WebRTC integration
- Custom protocol implementations

## Success Criteria

1. **Complete API coverage** - Every public Quinn method exposed
2. **Performance** - Minimal overhead over native Quinn
3. **Stability** - No memory leaks, proper error handling
4. **Documentation** - Every method documented with examples
5. **Testing** - Core functionality tested on iOS/Android

## Next Steps

1. Verify complete Quinn API surface from source code
2. Set up flutter_rust_bridge project structure
3. Implement Phase 1 (core connectivity)
4. Iterate through remaining phases
5. Testing and optimization