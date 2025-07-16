# Flutter QUIC

```
    ███████╗██╗     ██╗   ██╗████████╗████████╗███████╗██████╗ 
    ██╔════╝██║     ██║   ██║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗
    █████╗  ██║     ██║   ██║   ██║      ██║   █████╗  ██████╔╝
    ██╔══╝  ██║     ██║   ██║   ██║      ██║   ██╔══╝  ██╔══██╗
    ██║     ███████╗╚██████╔╝   ██║      ██║   ███████╗██║  ██║
    ╚═╝     ╚══════╝ ╚═════╝    ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝
    
                          ██████╗ ██╗   ██╗██╗ ██████╗
                         ██╔═══██╗██║   ██║██║██╔════╝
                         ██║   ██║██║   ██║██║██║     
                         ██║▄▄ ██║██║   ██║██║██║     
                         ╚██████╔╝╚██████╔╝██║╚██████╗
                          ╚══▀▀═╝  ╚═════╝ ╚═╝ ╚═════╝
```

[![Pub Version](https://img.shields.io/pub/v/flutter_quic.svg)](https://pub.dev/packages/flutter_quic)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)

**🧪 BETA SOFTWARE - Not recommended for production use yet.**

A Flutter plugin providing QUIC protocol support for mobile and desktop apps. Built on the [Quinn](https://github.com/quinn-rs/quinn) Rust library using [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge).

---

## ✨ What This Library Supports

### 🚀 **Core Features**
- ✅ **QUIC Client & Server** - Complete client/server implementation
- ✅ **TLS 1.3 built-in** - Security is not optional
- ✅ **Multiple streams** - Bidirectional and unidirectional over single connection
- ✅ **QUIC datagrams** - For unreliable messaging
- ✅ **Connection migration** - Seamless WiFi ↔ cellular switching
- ✅ **0-RTT reconnection** - Fast repeat connections
- ✅ **No head-of-line blocking** - Independent streams
- ✅ **HTTP-style API** - Easy adoption with convenience layer
- ✅ **Complete Quinn mapping** - Full access to underlying library

### 📱 **Platform Support**
| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ Supported | API 21+ |
| **iOS** | ✅ Supported | iOS 11+ |
| **Windows** | ✅ Supported | Windows 10+ |
| **macOS** | ✅ Supported | macOS 10.14+ |
| **Linux** | ✅ Supported | Modern distributions |
| **Web** | ❌ Not Supported | WebTransport planned |

### 🎯 **API Design**
- **Convenience API**: HTTP-style interface for common use cases
- **Core API**: Complete 1:1 Quinn mapping for advanced control
- **Async/Await**: Full Flutter integration
- **Memory Safe**: Rust ownership prevents leaks
- **Type Safe**: Generated bindings with compile-time safety

---

## 🤔 What is QUIC?

QUIC (Quick UDP Internet Connections) is the transport protocol powering HTTP/3. Originally developed by Google, now an IETF standard. Key benefits:

- **Faster connections** - 1 RTT setup vs 3 RTTs for TCP+TLS
- **Stream multiplexing** - No head-of-line blocking  
- **Connection migration** - Survives network changes
- **Built-in encryption** - TLS 1.3 integrated, not layered

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_quic: ^0.1.0-beta.3
```

Initialize in your app:

```dart
import 'package:flutter_quic/flutter_quic.dart';

void main() async {
  await RustLib.init();
  runApp(MyApp());
}
```

---

## 🚀 Examples

### Convenience API (HTTP-style)
Perfect for most use cases:

```dart
import 'package:flutter_quic/flutter_quic.dart';

// Create client (handles connection pooling)
final client = await quicClientCreate();

// Make requests
final response = await quicClientGet(
  client: client, 
  url: 'https://example.com/api/data'
);
print('Response: ${response.$2}');

// POST data
final postResult = await quicClientPost(
  client: client,
  url: 'https://example.com/api/submit',
  data: '{"message": "Hello QUIC!"}'
);
```

### Core API (Advanced)
For full Quinn control:

```dart
// Create endpoint and connect
final endpoint = await createClientEndpoint();
final connectResult = await endpointConnect(
  endpoint: endpoint,
  addr: '93.184.216.34:443',
  serverName: 'example.com'
);
final connection = connectResult.$2;

// Open bidirectional stream
final streamResult = await connectionOpenBi(connection: connection);
final sendStream = streamResult.$2;
final recvStream = streamResult.$3;

// Send and receive data
await sendStreamWriteAll(stream: sendStream, data: 'Hello, QUIC!'.codeUnits);
final readResult = await recvStreamReadToEnd(stream: recvStream, maxLength: BigInt.from(1024));
```

### QUIC Server
Create servers with TLS certificates:

```dart
// Load certificates (DER format required)
final certChain = [await File('server.crt.der').readAsBytes()];
final privateKey = await File('server.key.der').readAsBytes();

// Create server
final serverConfig = await serverConfigWithSingleCert(
  certChain: certChain,
  key: privateKey,
);
final serverEndpoint = await createServerEndpoint(
  config: serverConfig,
  addr: '127.0.0.1:4433',
);
```

### Real-World Use Cases

**Mobile App with Network Switching:**
```dart
class ApiService {
  late QuicClient _client;
  
  Future<void> init() async {
    await RustLib.init();
    _client = await quicClientCreate();
  }
  
  // Automatically handles WiFi ↔ cellular switching
  Future<UserProfile> getUserProfile(String userId) async {
    final result = await quicClientGet(
      client: _client,
      url: 'https://api.myapp.com/users/$userId'
    );
    return UserProfile.fromJson(jsonDecode(result.$2));
  }
}
```

**Real-time Gaming (Multiple Streams):**
```dart
// Multiple concurrent streams - no head-of-line blocking
final positionStream = await connectionOpenUni(connection: connection); // High frequency
final chatStream = await connectionOpenBi(connection: connection);      // Low frequency  
final eventsStream = await connectionOpenBi(connection: connection);    // Medium frequency
```

**Dashboard Loading (Concurrent Requests):**
```dart
// All requests over single QUIC connection
final results = await Future.wait([
  quicClientGet(client: client, url: 'https://api.com/analytics'),
  quicClientGet(client: client, url: 'https://api.com/notifications'),  
  quicClientGet(client: client, url: 'https://api.com/user-activity'),
  quicClientGet(client: client, url: 'https://api.com/system-status'),
]);
```

---

## 🔐 Certificate Requirements

**Important**: QUIC requires TLS certificates in **DER format** with **PKCS#8 private keys**.

### Development & Testing
Use the included certificate generator:

```bash
# In your example/ directory
./generate_certs.sh
```

Creates:
- `server.crt.der` - Certificate in DER format  
- `server.key.der` - Private key in PKCS#8 DER format

```dart
// Load from Flutter assets
final certBytes = await rootBundle.load('certs/server.crt.der');
final keyBytes = await rootBundle.load('certs/server.key.der');

final certChain = [certBytes.buffer.asUint8List()];
final privateKey = keyBytes.buffer.asUint8List().cast<int>().toList();
```

### Production Certificates
Convert existing certificates:

```bash
# Convert certificate to DER
openssl x509 -in server.crt -outform DER -out server.crt.der

# Convert private key to PKCS#8 DER
openssl pkey -in server.key -outform DER -out server.key.der
```

**Certificate Sources:**
- 🆓 **Let's Encrypt** - Free automated certificates
- ☁️ **Cloud providers** - AWS ACM, Google Cloud SSL, Azure Key Vault  
- 🏢 **Corporate CA** - Your organization's certificate authority
- 🧪 **Development** - Use `./generate_certs.sh` for local testing

---

## 🛡️ Error Handling

Specific error types for different scenarios:

```dart
try {
  final result = await quicClientGet(client: client, url: 'https://example.com');
} on QuicError catch (e) {
  switch (e) {
    case QuicError.connection(field0: final message):
      print('Connection failed: $message');
      // Retry logic
      
    case QuicError.endpoint(field0: final message):
      print('Endpoint error: $message');
      // Check network
      
    case QuicError.stream(field0: final message):
      print('Stream error: $message');
      // Handle stream issues
  }
}
```

---

## 🔧 Complete API Reference

### Convenience API
```dart
// Client creation
Future<QuicClient> quicClientCreate()
Future<QuicClient> quicClientCreateWithConfig({required QuicClientConfig config})

// HTTP-style methods
Future<(QuicClient, String)> quicClientGet({required QuicClient client, required String url})
Future<(QuicClient, String)> quicClientPost({required QuicClient client, required String url, required String data})

// With timeouts
Future<(QuicClient, String)> quicClientGetWithTimeout({required QuicClient client, required String url})
Future<(QuicClient, String)> quicClientPostWithTimeout({required QuicClient client, required String url, required String data})

// Management
Future<(QuicClient, QuicClientConfig)> quicClientConfig({required QuicClient client})
Future<QuicClient> quicClientClearPool({required QuicClient client})
```

### Core API
```dart
// Endpoints
Future<QuicEndpoint> createClientEndpoint()
Future<QuicEndpoint> createServerEndpoint({required QuicServerConfig config, required String addr})
Future<QuicServerConfig> serverConfigWithSingleCert({required List<Uint8List> certChain, required List<int> key})

// Connections
Future<(QuicEndpoint, QuicConnection)> endpointConnect({required QuicEndpoint endpoint, required String addr, required String serverName})
Future<(QuicConnection, QuicSendStream, QuicRecvStream)> connectionOpenBi({required QuicConnection connection})
Future<(QuicConnection, QuicSendStream)> connectionOpenUni({required QuicConnection connection})

// Streams
Future<QuicSendStream> sendStreamWriteAll({required QuicSendStream stream, required List<int> data})
Future<(QuicRecvStream, Uint8List)> recvStreamReadToEnd({required QuicRecvStream stream, required BigInt maxLength})
```

---

## ❌ Current Limitations

- ❌ **WebTransport** - Web platform not supported (Quinn is native only)
- ❌ **HTTP/3 semantic layer** - Raw QUIC transport only  
- ❌ **Connection resumption** across app restarts
- ❌ **Advanced TLS certificate validation** - Basic validation only

---

## 🤝 Contributing

This project follows strict quality standards:

- **No Placeholders** - All code must be production-ready
- **Real Implementation** - No mock implementations  
- **Comprehensive Testing** - Unit and integration tests required
- **Documentation** - All public APIs documented

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file.

---

## 🙏 Acknowledgments

- **[Quinn](https://github.com/quinn-rs/quinn)** - QUIC implementation
- **[flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge)** - Rust-Flutter integration
- **Google's QUIC team** - Protocol innovation
- **IETF QUIC Working Group** - Standardization

---

## 🚨 Beta Status

**This library is experimental and under active development.**

- ✅ Safe for experimentation and learning
- ⚠️ **Not recommended for production** apps  
- 🔄 API may change before stable release
- 🧪 Beta testing with community feedback ongoing

*Ready to try QUIC? Feedback and contributions welcome!*

