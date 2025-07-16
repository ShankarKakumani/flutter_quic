# Flutter QUIC Bridge - Project Brief

## What We're Building
Direct 1:1 mapping of Quinn Rust QUIC library to Flutter/Dart using flutter_rust_bridge. Complete API exposure with zero custom protocol logic.

## Core Architecture - Two-Tier API Design

### Core API (Direct Quinn mapping - PRIORITY 1)
```rust
// Rust side - Direct Quinn wrappers (FULL POWER)
pub struct QuicEndpoint(Endpoint);
pub struct QuicConnection(Connection);  
pub struct QuicSendStream(SendStream);
pub struct QuicRecvStream(RecvStream);
```

```dart
// Flutter side - Complete Quinn API access
final endpoint = await QuicEndpoint.client(config);
final connection = await endpoint.connect("127.0.0.1:4433", "localhost");
final (sendStream, recvStream) = await connection.openBi();
await sendStream.write(data);
final response = await recvStream.readToEnd(1024);
```

### Convenience API (Simple wrapper - PRIORITY 2)
```dart
// Built on top of Core API - for 80% of users
final quic = QuicClient();
final response = await quic.send('https://api.com:4433', data: 'hello');

// Multiple clients for different purposes
final apiClient = QuicClient(baseUrl: 'https://api.com:4433');
final wsClient = QuicClient(config: QuicConfig(keepAlive: true));
```

## Key Decisions
- **Core API first** - Complete 1:1 Quinn mapping with full power (Priority 1)
- **Convenience API second** - Simple wrapper built on Core API (Priority 2)
- **No functionality lost** - Core API exposes every Quinn method
- **Opaque objects** - Rust owns everything, Flutter holds handles
- **Direct async bridging** - Rust Future → Dart Future, preserve error context
- **Complete coverage** - Every public Quinn method exposed in Core API

## Success Criteria
1. ✅ All Quinn public methods accessible from Flutter
2. ✅ Zero memory leaks, proper lifecycle management  
3. ✅ Performance: <5% overhead vs native Quinn
4. ✅ Works on iOS + Android
5. ✅ Complete documentation + examples

## Implementation Phases
- **Phase 1**: Core API - Endpoint + Connection
- **Phase 2**: Core API - Complete Quinn surface  
- **Phase 3**: Convenience API + Polish + Testing

## Technical Stack
- **Rust**: Quinn + flutter_rust_bridge
- **Flutter**: Standard Dart bindings
- **Platforms**: iOS, Android
- **Build**: Standard Flutter package

## Scope Boundaries
✅ **Included**: Complete Quinn QUIC functionality
- Stream multiplexing (bi/unidirectional)
- Datagram support  
- 0-RTT connection resumption
- Connection migration
- Congestion control
- Certificate validation
- Flow control & backpressure

❌ **Separate projects** (not Quinn features):
- HTTP/3 (use `h3-quinn` crate)
- WebRTC integration
- Custom protocol implementations

---
*Total estimated effort: 42-54 hours → 4-5 focused Cursor sessions* 