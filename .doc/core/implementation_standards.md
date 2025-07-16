# Implementation Standards - NO PLACEHOLDERS

## 🚨 CRITICAL: Production Code Only

### ❌ **NEVER DO THIS**
```rust
// WRONG - Placeholder implementation
pub async fn send_data(&self, data: Vec<u8>) -> Result<Vec<u8>, QuicError> {
    // TODO: Implement actual sending
    Ok(b"dummy response".to_vec())
}

// WRONG - Generic error handling
pub fn connect(&self, addr: String) -> Result<Connection, Box<dyn Error>> {
    // Generic error handling
}

// WRONG - Hardcoded test values
pub fn local_addr(&self) -> SocketAddr {
    "127.0.0.1:4433".parse().unwrap()
}
```

### ✅ **ALWAYS DO THIS**
```rust
// CORRECT - Real Quinn implementation
pub async fn send_data(&self, data: Vec<u8>) -> Result<Vec<u8>, QuicError> {
    let (mut send_stream, mut recv_stream) = self.0.open_bi().await?;
    send_stream.write_all(&data).await?;
    send_stream.finish().await?;
    recv_stream.read_to_end(1024 * 1024).await.map_err(QuicError::from)
}

// CORRECT - Specific Quinn error types
pub async fn connect(&self, addr: String, server_name: String) -> Result<QuicConnection, ConnectError> {
    let connecting = self.0.connect(addr.parse()?, &server_name)?;
    let connection = connecting.await?;
    Ok(QuicConnection(connection))
}

// CORRECT - Real Quinn method call
pub fn local_addr(&self) -> Result<SocketAddr, EndpointError> {
    self.0.local_addr()
}
```

## 🔧 **Implementation Requirements**

### 1. **Real Quinn API Calls**
- Every method MUST call the actual Quinn method
- No dummy data, no placeholders, no TODOs
- Use `self.0.quinn_method()` pattern for wrappers

### 2. **Specific Error Types**
- Map exact Quinn error types to Dart exceptions
- No generic `Box<dyn Error>` or `anyhow::Error`
- Use `#[derive(Debug, thiserror::Error)]` for custom errors

### 3. **Real Data Flow**
- Actual bytes sent/received over network
- Real QUIC handshakes and connections
- Proper stream multiplexing and flow control

### 4. **Memory Management**
- Use `#[frb(opaque)]` for Quinn objects
- Rust owns all objects, Flutter holds handles
- Proper async bridging with real futures

## 📋 **Code Review Checklist**

Before any code is complete, verify:

- [ ] **No placeholder returns** - Every method returns real Quinn data
- [ ] **No dummy implementations** - All logic calls actual Quinn APIs
- [ ] **No generic errors** - Specific error types for each Quinn error
- [ ] **No hardcoded values** - All values come from Quinn or user input
- [ ] **No TODOs in production** - Complete implementation required
- [ ] **Real network operations** - Actual QUIC protocol communication
- [ ] **Proper async handling** - Real futures, not blocking operations
- [ ] **Memory safety** - No leaks, proper resource cleanup

## 🎯 **Success Validation**

### Phase 1 Validation
```rust
// This MUST work with real QUIC handshake
#[tokio::test]
async fn test_real_connection() {
    let endpoint = QuicEndpoint::client(real_client_config()).await.unwrap();
    let connection = endpoint.connect("api.myservice.com:4433", "api.myservice.com").await.unwrap();
    let (mut send, mut recv) = connection.open_bi().await.unwrap();
    
    send.write_all(b"real data").await.unwrap();
    send.finish().await.unwrap();
    
    let response = recv.read_to_end(1024).await.unwrap();
    assert!(!response.is_empty()); // Real response, not empty
}
```

### Error Handling Validation
```rust
#[tokio::test]
async fn test_real_error_handling() {
    let endpoint = QuicEndpoint::client(real_client_config()).await.unwrap();
    
    // This should return actual Quinn ConnectError, not generic error
    let result = endpoint.connect("invalid.domain:4433", "invalid.domain").await;
    match result {
        Err(ConnectError::InvalidDnsName(_)) => { /* Expected */ },
        _ => panic!("Should return specific Quinn error"),
    }
}
```

## 🚫 **Forbidden Patterns**

### Never Use These
- `unimplemented!()`
- `todo!()`
- `panic!("Not implemented")`
- `Ok(Vec::new())` as placeholder
- `"dummy"` or `"placeholder"` in any string
- Generic error types without Quinn mapping
- Hardcoded test data in production methods

### Always Use These
- `self.0.quinn_method()` for direct Quinn calls
- Specific Quinn error type mapping
- Real async operations with proper error handling
- Actual network communication
- Production-ready resource management

## 🔍 **Context for Cursor + Claude**

When implementing ANY method:

1. **Find the exact Quinn method** - Use codebase search for Quinn API
2. **Check Quinn documentation** - Understand exact behavior
3. **Map error types precisely** - No generic error handling
4. **Test with real network** - Actual QUIC connections required
5. **Verify memory safety** - Proper resource cleanup

**Remember**: This is production code from day one. No placeholders, no rework needed. 