# Type Mappings: Quinn → Flutter

## Core API Types (Priority 1 - Full Quinn Power)

| Quinn Type | Rust Wrapper | Dart Type | Example |
|------------|--------------|-----------|---------|
| `quinn::Endpoint` | `QuicEndpoint` | `QuicEndpoint` | `QuicEndpoint.client(config)` |
| `quinn::Connection` | `QuicConnection` | `QuicConnection` | `endpoint.connect("127.0.0.1:4433", "localhost")` |
| `quinn::SendStream` | `QuicSendStream` | `QuicSendStream` | `connection.openBi()` |
| `quinn::RecvStream` | `QuicRecvStream` | `QuicRecvStream` | `connection.openBi()` |
| `quinn::Connecting` | `QuicConnecting` | `QuicConnecting` | `endpoint.connect()` |

## Convenience API Types (Priority 2 - 80% of users)

| Concept | Rust Type | Dart Type | Example |
|---------|-----------|-----------|---------|
| Client | `QuicClient` | `QuicClient` | `QuicClient()` |
| Config | `QuicConfig` | `QuicConfig` | `QuicConfig(timeout: Duration(seconds: 30))` |
| Request | `String, Vec<u8>` | `String, String` | `client.send('https://api.com', data: 'hello')` |
| Response | `Vec<u8>` | `String` | `'response data'` |
| Error | `QuicError` | `QuicException` | `throw QuicException('Connection failed')` |

## Core API Implementation Details

## Core QUIC Types

| Quinn Type | Rust Wrapper | Dart Type | Notes |
|------------|--------------|-----------|-------|
| `quinn::Endpoint` | `QuicEndpoint` | `QuicEndpoint` | Opaque handle |
| `quinn::Connection` | `QuicConnection` | `QuicConnection` | Opaque handle |
| `quinn::SendStream` | `QuicSendStream` | `QuicSendStream` | Opaque handle |
| `quinn::RecvStream` | `QuicRecvStream` | `QuicRecvStream` | Opaque handle |
| `quinn::Connecting` | `QuicConnecting` | `QuicConnecting` | Opaque handle |

## Primitive Types

| Quinn Type | Rust Bridge | Dart Type | Example |
|------------|-------------|-----------|---------|
| `u8` | `u8` | `int` | `255` |
| `u16` | `u16` | `int` | `65535` |
| `u32` | `u32` | `int` | `4294967295` |
| `u64` | `u64` | `int` | `9223372036854775807` |
| `usize` | `u64` | `int` | Convert via `as u64` |
| `bool` | `bool` | `bool` | `true/false` |
| `String` | `String` | `String` | `"hello"` |

## Network Types

| Quinn Type | Rust Bridge | Dart Type | Example |
|------------|-------------|-----------|---------|
| `SocketAddr` | `String` | `String` | `"127.0.0.1:8080"` |
| `IpAddr` | `String` | `String` | `"192.168.1.1"` |
| `Duration` | `u64` | `int` | Milliseconds |

## Data Types

| Quinn Type | Rust Bridge | Dart Type | Notes |
|------------|-------------|-----------|-------|
| `Vec<u8>` | `Vec<u8>` | `Uint8List` | Byte arrays |
| `Bytes` | `Vec<u8>` | `Uint8List` | Convert via `.to_vec()` |
| `&[u8]` | `Vec<u8>` | `Uint8List` | Convert via `.to_vec()` |
| `&str` | `String` | `String` | Convert via `.to_string()` |

## QUIC-Specific Types

| Quinn Type | Rust Bridge | Dart Type | Conversion |
|------------|-------------|-----------|------------|
| `VarInt` | `u64` | `int` | `varint.into_inner()` |
| `StreamId` | `u64` | `int` | `stream_id.into_inner()` |
| `ConnectionId` | `String` | `String` | `format!("{:?}", conn_id)` |

## Configuration Types

| Quinn Type | Rust Wrapper | Dart Type | Notes |
|------------|--------------|-----------|-------|
| `ClientConfig` | `QuicClientConfig` | `QuicClientConfig` | Opaque |
| `ServerConfig` | `QuicServerConfig` | `QuicServerConfig` | Opaque |
| `EndpointConfig` | `QuicEndpointConfig` | `QuicEndpointConfig` | Opaque |
| `TransportConfig` | `QuicTransportConfig` | `QuicTransportConfig` | Opaque |

## Error Types

| Quinn Type | Rust Bridge | Dart Exception | Conversion |
|------------|-------------|----------------|------------|
| `ConnectionError` | `String` | `Exception` | `error.to_string()` |
| `WriteError` | `String` | `Exception` | `error.to_string()` |
| `ReadError` | `String` | `Exception` | `error.to_string()` |
| `ConnectError` | `String` | `Exception` | `error.to_string()` |
| `EndpointError` | `String` | `Exception` | `error.to_string()` |

## Statistics Types

| Quinn Type | Rust Bridge | Dart Type | Notes |
|------------|-------------|-----------|-------|
| `ConnectionStats` | `QuicConnectionStats` | `QuicConnectionStats` | Struct with fields |
| `PathStats` | `QuicPathStats` | `QuicPathStats` | Struct with fields |
| `UdpStats` | `QuicUdpStats` | `QuicUdpStats` | Struct with fields |

## Future/Async Types

| Quinn Type | Rust Bridge | Dart Type | Notes |
|------------|-------------|-----------|-------|
| `OpenBi` | `Future<(QuicSendStream, QuicRecvStream)>` | `Future<(QuicSendStream, QuicRecvStream)>` | Tuple return |
| `OpenUni` | `Future<QuicSendStream>` | `Future<QuicSendStream>` | Single return |
| `AcceptBi` | `Future<(QuicSendStream, QuicRecvStream)>` | `Future<(QuicSendStream, QuicRecvStream)>` | Tuple return |
| `AcceptUni` | `Future<QuicRecvStream>` | `Future<QuicRecvStream>` | Single return |
| `Read` | `Future<Option<Vec<u8>>>` | `Future<Uint8List?>` | Nullable return |
| `Write` | `Future<u64>` | `Future<int>` | Bytes written |

## Option Types

| Quinn Type | Rust Bridge | Dart Type | Notes |
|------------|-------------|-----------|-------|
| `Option<T>` | `Option<T>` | `T?` | Nullable types |
| `Option<usize>` | `Option<u64>` | `int?` | Nullable int |
| `Option<Vec<u8>>` | `Option<Vec<u8>>` | `Uint8List?` | Nullable bytes |

## Result Types

| Quinn Type | Rust Bridge | Dart Type | Notes |
|------------|-------------|-----------|-------|
| `Result<T, E>` | `Future<T>` | `Future<T>` | Throws on error |
| `Result<(), WriteError>` | `Future<void>` | `Future<void>` | Void return |
| `Result<usize, ReadError>` | `Future<int>` | `Future<int>` | Int return |

## Complex Data Structures

### ConnectionStats Mapping
```rust
// Rust side
#[derive(Debug)]
pub struct QuicConnectionStats {
    pub rtt: u64,                    // Duration as milliseconds
    pub bytes_sent: u64,
    pub bytes_received: u64,
    pub packets_sent: u64,
    pub packets_received: u64,
    pub path_rtt: u64,
    pub path_cwnd: u64,
}

impl From<quinn::ConnectionStats> for QuicConnectionStats {
    fn from(stats: quinn::ConnectionStats) -> Self {
        Self {
            rtt: stats.path.rtt.as_millis() as u64,
            bytes_sent: stats.udp_tx.bytes,
            bytes_received: stats.udp_rx.bytes,
            packets_sent: stats.udp_tx.datagrams,
            packets_received: stats.udp_rx.datagrams,
            path_rtt: stats.path.rtt.as_millis() as u64,
            path_cwnd: stats.path.cwnd,
        }
    }
}
```

```dart
// Dart side
class QuicConnectionStats {
  final int rtt;
  final int bytesSent;
  final int bytesReceived;
  final int packetsSent;
  final int packetsReceived;
  final int pathRtt;
  final int pathCwnd;
  
  const QuicConnectionStats({
    required this.rtt,
    required this.bytesSent,
    required this.bytesReceived,
    required this.packetsSent,
    required this.packetsReceived,
    required this.pathRtt,
    required this.pathCwnd,
  });
}
```

## Type Conversion Helpers

### Rust Side Conversions
```rust
// SocketAddr to String
pub fn socket_addr_to_string(addr: SocketAddr) -> String {
    addr.to_string()
}

// Duration to milliseconds
pub fn duration_to_millis(duration: Duration) -> u64 {
    duration.as_millis() as u64
}

// Bytes to Vec<u8>
pub fn bytes_to_vec(bytes: Bytes) -> Vec<u8> {
    bytes.to_vec()
}

// VarInt to u64
pub fn varint_to_u64(varint: VarInt) -> u64 {
    varint.into_inner()
}
```

### Dart Side Conversions
```dart
// String to SocketAddr (for display)
String formatSocketAddr(String addr) => addr;

// Milliseconds to Duration
Duration millisToDuration(int millis) => Duration(milliseconds: millis);

// Uint8List to String (for debugging)
String bytesToString(Uint8List bytes) => String.fromCharCodes(bytes);
```

## Special Cases

### Enum Mappings
```rust
// Rust enum
#[derive(Debug)]
pub enum QuicSide {
    Client,
    Server,
}

impl From<quinn::Side> for QuicSide {
    fn from(side: quinn::Side) -> Self {
        match side {
            quinn::Side::Client => QuicSide::Client,
            quinn::Side::Server => QuicSide::Server,
        }
    }
}
```

```dart
// Dart enum
enum QuicSide {
  client,
  server,
}
```

### Tuple Returns
```rust
// Rust tuple return
pub async fn open_bi(&self) -> Result<(QuicSendStream, QuicRecvStream), String> {
    // Implementation
}
```

```dart
// Dart tuple destructuring
final (sendStream, recvStream) = await connection.openBi();
```

## Memory Management

| Type Category | Rust Ownership | Dart Lifecycle | Notes |
|---------------|----------------|----------------|-------|
| Opaque Objects | Rust owns | Auto-cleanup | `#[frb(opaque)]` |
| Primitive Types | Copy | Value semantics | No cleanup needed |
| Byte Arrays | Copy to Dart | Dart GC | Copied across boundary |
| Strings | Copy to Dart | Dart GC | UTF-8 conversion |

---
*Type mappings for Quinn 0.11.x + flutter_rust_bridge 2.x* 