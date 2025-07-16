# Quinn Essentials Reference

## Core API Patterns (Priority 1 - Full Quinn Power)

### Direct Quinn Usage
```dart
// Complete Quinn API access
final endpoint = await QuicEndpoint.client(config);
final connection = await endpoint.connect("127.0.0.1:4433", "localhost");

// Bidirectional streams
final (sendStream, recvStream) = await connection.openBi();
await sendStream.write(data);
final response = await recvStream.readToEnd(1024);

// Unidirectional streams
final sendStream = await connection.openUni();
await sendStream.writeAll(data);
await sendStream.finish();

// Datagrams
await connection.sendDatagram(data);
final datagram = await connection.readDatagram();
```

### Advanced Features
- **Stream multiplexing** - Multiple streams per connection
- **Flow control** - Automatic backpressure handling
- **Connection migration** - Seamless network switching
- **0-RTT resumption** - Faster reconnection

---

## Production Usage Patterns

### Real Server Connection
```rust
// Production server connection - NOT example.com
let endpoint = Endpoint::client(client_config)?;
let connecting = endpoint.connect("api.myservice.com:4433".parse()?, "api.myservice.com")?;
let connection = connecting.await?;

// Real certificate validation
let client_config = ClientConfig::with_native_roots()
    .with_alpn_protocols(&[b"h3"]);
```

### Error Handling (Production Ready)
```rust
// Specific Quinn error handling - NOT generic exceptions
match endpoint.connect(server_addr, "api.myservice.com") {
    Ok(connecting) => {
        match connecting.await {
            Ok(connection) => { /* use connection */ },
            Err(ConnectionError::TransportError(e)) => {
                // Handle transport errors specifically
                eprintln!("Transport error: {}", e);
            },
            Err(ConnectionError::ApplicationClosed(e)) => {
                // Handle application closure
                eprintln!("Application closed: {}", e);
            },
            Err(ConnectionError::Reset) => {
                // Handle connection reset
                eprintln!("Connection reset");
            },
            Err(ConnectionError::TimedOut) => {
                // Handle timeout
                eprintln!("Connection timed out");
            },
        }
    },
    Err(ConnectError::EndpointStopping) => {
        eprintln!("Endpoint is stopping");
    },
    Err(ConnectError::TooManyConnections) => {
        eprintln!("Too many connections");
    },
    Err(ConnectError::InvalidDnsName(_)) => {
        eprintln!("Invalid DNS name");
    },
    Err(ConnectError::InvalidRemoteAddress(_)) => {
        eprintln!("Invalid remote address");
    },
    Err(ConnectError::NoDefaultClientConfig) => {
        eprintln!("No default client config");
    },
}
```

## Convenience API Patterns (Priority 2 - 80% of users)

### QuicClient Usage
```dart
// Simple request/response
final client = QuicClient();
final response = await client.send('https://api.com:4433', data: 'hello');

// With configuration
final client = QuicClient(
  config: QuicConfig(
    timeout: Duration(seconds: 30),
    keepAlive: true,
    maxConnections: 10,
  ),
);

// Different clients for different purposes
final apiClient = QuicClient(baseUrl: 'https://api.com:4433');
final wsClient = QuicClient(config: QuicConfig(keepAlive: true));
```

### Built-in Features
- **Connection pooling** - Automatic connection reuse
- **Error handling** - Automatic retries and error recovery
- **Interceptors** - Request/response middleware
- **Certificates** - Automatic certificate management

---

## Core API Implementation Details

## Core Quinn Types

### Primary Objects
```rust
// Main QUIC endpoint - creates connections
pub struct Endpoint { /* ... */ }

// Active QUIC connection
pub struct Connection { /* ... */ }

// Unidirectional stream for sending
pub struct SendStream { /* ... */ }

// Unidirectional stream for receiving  
pub struct RecvStream { /* ... */ }

// Pending connection (before established)
pub struct Connecting { /* ... */ }
```

### Key Result Types
```rust
// Common error patterns
Result<T, EndpointError>
Result<T, ConnectionError>
Result<T, WriteError>
Result<T, ReadError>
Result<T, ConnectError>
```

## Essential API Patterns

### 1. Endpoint Creation
```rust
// Client endpoint
let endpoint = Endpoint::client(endpoint_config)?;

// Server endpoint  
let endpoint = Endpoint::server(server_config, endpoint_config)?;
```

### 2. Connection Flow
```rust
// Client: initiate connection
let connecting = endpoint.connect(server_addr, "example.com")?;
let connection = connecting.await?;

// Server: accept connection
let connecting = endpoint.accept().await;
let connection = connecting.await?;
```

### 3. Stream Operations
```rust
// Open bidirectional stream
let (send, recv) = connection.open_bi().await?;

// Open unidirectional stream
let send = connection.open_uni().await?;

// Accept incoming streams
let (send, recv) = connection.accept_bi().await?;
let recv = connection.accept_uni().await?;
```

### 4. Data Transfer
```rust
// Send data
send_stream.write_all(b"hello").await?;
send_stream.finish().await?;

// Receive data
let mut buf = [0; 1024];
let n = recv_stream.read(&mut buf).await?;
```

### 5. Datagram Operations
```rust
// Send datagram (immediate)
connection.send_datagram(Bytes::from("datagram data"))?;

// Send datagram (wait for space)
connection.send_datagram_wait(Bytes::from("datagram data")).await?;

// Receive datagram
let data = connection.read_datagram().await?;

// Check buffer space
let space = connection.datagram_send_buffer_space();
```

## Error Handling Patterns

### Common Error Types
```rust
// Connection errors
ConnectionError::LocallyClosed
ConnectionError::ApplicationClosed { error_code, reason }
ConnectionError::Reset
ConnectionError::TimedOut

// Stream errors
WriteError::Stopped(error_code)
WriteError::ConnectionLost(conn_err)
ReadError::Reset(error_code)
ReadError::ConnectionLost(conn_err)
```

### Async Patterns
```rust
// Most operations return Future<Result<T, E>>
async fn example() -> Result<(), Box<dyn std::error::Error>> {
    let data = recv_stream.read_to_end(1024).await?;
    send_stream.write_all(&data).await?;
    Ok(())
}
```

## Configuration Essentials

### Client Config
```rust
let mut config = ClientConfig::with_native_roots();
config.alpn_protocols = vec![b"h3".to_vec()];
```

### Server Config  
```rust
let cert = Certificate::from_pem(&cert_pem)?;
let key = PrivateKey::from_pem(&key_pem)?;
let config = ServerConfig::with_single_cert(vec![cert], key)?;
```

### Transport Config
```rust
let mut transport = TransportConfig::default();
transport.max_concurrent_bidi_streams(100u32.into());
transport.max_concurrent_uni_streams(100u32.into());
```

## Key Async Futures

### Connection Futures
- `Connecting::await` → `Result<Connection, ConnectionError>`
- `Connection::closed()` → `Future<ConnectionError>`
- `Endpoint::accept()` → `Accept` (Future<Connecting>)
- `Endpoint::wait_idle()` → `Future<()>`

### Stream Futures
- `Connection::open_bi()` → `OpenBi` (Future<(SendStream, RecvStream)>)
- `Connection::open_uni()` → `OpenUni` (Future<SendStream>)
- `Connection::accept_bi()` → `AcceptBi` (Future<(SendStream, RecvStream)>)
- `Connection::accept_uni()` → `AcceptUni` (Future<RecvStream>)
- `SendStream::write()` → `Write` (Future<Result<usize, WriteError>>)
- `RecvStream::read()` → `Read` (Future<Result<Option<usize>, ReadError>>)

### Datagram Futures
- `Connection::read_datagram()` → `ReadDatagram` (Future<Bytes>)
- `Connection::send_datagram_wait()` → `SendDatagram` (Future<()>)

## Stats & Introspection
```rust
// Connection statistics
let stats = connection.stats();
println!("RTT: {:?}", stats.path.rtt);
println!("Bytes sent: {}", stats.udp_tx.bytes);

// Endpoint statistics
let stats = endpoint.stats();
println!("Connections: {}", stats.connections);
```

---
*Reference for Quinn v0.10+ API patterns* 