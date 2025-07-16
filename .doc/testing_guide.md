# Testing Guide - Flutter QUIC Package

## Overview

This guide shows how to test the Flutter QUIC package, including both the Core API and Convenience API implementations.

## Prerequisites

1. **Rust toolchain** (for building the native library)
2. **Flutter 3.19+** 
3. **Xcode/Android Studio** (for mobile testing)

## Setup

### 1. Build the Rust Library

```bash
# From project root
cd rust
cargo build --release
```

### 2. Generate Dart Bindings

```bash
# From project root  
flutter_rust_bridge_codegen generate
```

### 3. Get Dependencies

```bash
flutter pub get
cd example && flutter pub get
```

## Testing Methods

### Method 1: Example App (Interactive Testing)

The example app provides a comprehensive interactive test of all APIs:

```bash
# Run the example app
cd example
flutter run
```

**What it tests:**
- ✅ Core API endpoint creation
- ✅ Convenience API structure  
- ✅ QuicClient creation and configuration
- ✅ HTTP-style methods (get, post, send)
- ✅ Connection pooling and error handling
- ✅ Retry logic demonstration
- ✅ Timeout protection

**Expected behavior:**
- All API structure tests should pass ✅
- Network requests will fail (expected without QUIC server) ❌
- Error handling demonstrates proper retry logic ✅

### Method 2: Unit Tests (API Structure Testing)

Run unit tests to verify API structure:

```bash
# Run all unit tests
flutter test test/unit/

# Run specific convenience API tests
flutter test test/unit/convenience_api_test.dart
```

**What it tests:**
- ✅ QuicClient creation and configuration
- ✅ HTTP-style method signatures
- ✅ Core API availability alongside Convenience API
- ✅ Type safety and error handling structure

### Method 3: Integration Testing (With Real QUIC Server)

For full end-to-end testing, set up a QUIC server:

#### Option A: Simple QUIC Echo Server

```rust
// Create a simple QUIC echo server for testing
use quinn::{Endpoint, ServerConfig};
use std::net::SocketAddr;

#[tokio::main]
async fn main() {
    let mut endpoint = Endpoint::server(
        server_config, 
        "127.0.0.1:4433".parse().unwrap()
    ).unwrap();
    
    while let Some(conn) = endpoint.accept().await {
        tokio::spawn(handle_connection(conn.await.unwrap()));
    }
}

async fn handle_connection(conn: quinn::Connection) {
    while let Ok((mut send, mut recv)) = conn.accept_bi().await {
        let data = recv.read_to_end(1024).await.unwrap();
        send.write_all(&data).await.unwrap();
        send.finish().unwrap();
    }
}
```

#### Option B: Use httpbin with QUIC Support

Some services provide QUIC endpoints for testing:

```dart
// Test with real QUIC endpoints
final client = await quicClientCreate();

try {
  final (_, response) = await quicClientGet(
    client: client,
    url: 'https://quic-enabled-server.com/api/test'
  );
  print('Success: $response');
} catch (e) {
  print('Error: $e');
}
```

## API Testing Examples

### Core API Testing

```dart
import 'package:flutter_quic/flutter_quic.dart' as quic;

void testCoreAPI() async {
  await quic.RustLib.init();
  
  // Test endpoint creation
  final endpoint = await quic.createClientEndpoint();
  print('✅ Endpoint created: ${endpoint.runtimeType}');
  
  // Test connection (will fail without server)
  try {
    final (_, connection) = await quic.endpointConnect(
      endpoint: endpoint,
      addr: '127.0.0.1:4433',
      serverName: 'localhost'
    );
    print('✅ Connected: ${connection.runtimeType}');
  } catch (e) {
    print('❌ Connection failed (expected): $e');
  }
}
```

### Convenience API Testing

```dart
import 'package:flutter_quic/flutter_quic.dart' as quic;

void testConvenienceAPI() async {
  await quic.RustLib.init();
  
  // Test client creation
  final client = await quic.quicClientCreate();
  print('✅ Client created: ${client.runtimeType}');
  
  // Test configuration
  final (clientWithConfig, config) = await quic.quicClientConfig(client: client);
  print('✅ Config accessed: max connections = ${config.maxConnectionsPerHost}');
  
  // Test HTTP-style methods
  try {
    final (_, response) = await quic.quicClientGet(
      client: clientWithConfig,
      url: 'https://httpbin.org/get'
    );
    print('✅ GET succeeded: $response');
  } catch (e) {
    print('❌ GET failed (expected without QUIC server): $e');
  }
}
```

## Expected Test Results

### Without QUIC Server (API Structure Testing)

| Test | Expected Result | Status |
|------|----------------|--------|
| QuicClient creation | ✅ Success | Pass |
| Configuration access | ✅ Success | Pass |
| HTTP method calls | ❌ Connection error | Pass (expected) |
| Retry logic | ❌ Multiple attempts, final error | Pass (expected) |
| Pool management | ✅ Success | Pass |

### With QUIC Server (Full Integration)

| Test | Expected Result | Status |
|------|----------------|--------|
| GET requests | ✅ Response data | Pass |
| POST requests | ✅ Response data | Pass |
| Connection pooling | ✅ Reused connections | Pass |
| Retry logic | ✅ Success after retries | Pass |
| Timeout handling | ✅ or ❌ Timeout error | Pass |

## Performance Testing

For performance testing against HTTP/2:

```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_quic/flutter_quic.dart' as quic;

void performanceTest() async {
  const testUrl = 'https://httpbin.org/json';
  const iterations = 100;
  
  // Test HTTP/2
  final httpClient = http.Client();
  final httpStart = DateTime.now();
  for (int i = 0; i < iterations; i++) {
    await httpClient.get(Uri.parse(testUrl));
  }
  final httpDuration = DateTime.now().difference(httpStart);
  
  // Test QUIC
  final quicClient = await quic.quicClientCreate();
  final quicStart = DateTime.now();
  for (int i = 0; i < iterations; i++) {
    try {
      await quic.quicClientGet(client: quicClient, url: testUrl);
    } catch (e) {
      // Handle QUIC connection errors
    }
  }
  final quicDuration = DateTime.now().difference(quicStart);
  
  print('HTTP/2: ${httpDuration.inMilliseconds}ms');
  print('QUIC: ${quicDuration.inMilliseconds}ms');
}
```

## Troubleshooting

### Common Issues

1. **"flutter_rust_bridge has not been initialized"**
   - Solution: Call `await RustLib.init()` before using any APIs

2. **"Failed to load dynamic library"**
   - Solution: Build the Rust library with `cargo build --release`

3. **"Connection refused" errors**
   - Expected: No QUIC server running
   - Solution: Set up a QUIC server or test API structure only

4. **Compilation errors**
   - Solution: Run `flutter_rust_bridge_codegen generate` to regenerate bindings

### Debug Output

Enable verbose logging:

```dart
import 'package:flutter/foundation.dart';

void main() {
  if (kDebugMode) {
    // Enable debug output for development
  }
  runApp(MyApp());
}
```

## Continuous Integration

For CI/CD pipelines:

```yaml
# .github/workflows/test.yml
name: Test Flutter QUIC
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
      
      - name: Build Rust library
        run: cd rust && cargo build --release
      
      - name: Generate bindings
        run: flutter_rust_bridge_codegen generate
      
      - name: Run tests
        run: flutter test
      
      - name: Test example app
        run: cd example && flutter test
```

## Summary

The Flutter QUIC package can be tested at multiple levels:

1. **API Structure**: Works without any servers
2. **Error Handling**: Demonstrates proper retry/timeout behavior  
3. **Integration**: Requires real QUIC server for full testing
4. **Performance**: Compare against HTTP/2 with real servers

Most development and CI testing can be done using the API structure tests, while integration testing with real servers validates production readiness. 