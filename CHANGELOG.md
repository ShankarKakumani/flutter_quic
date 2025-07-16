# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3-beta] - 2025-07-16

### Changed
- **Release automation**: Simplified GitHub Actions workflow for tag-based publishing
- **Version management**: Enhanced release script with smart version suggestions
- **Workflow optimization**: Removed unnecessary binding generation from automated releases

## [0.1.0-beta.4] - 2025-07-16

### Changed
- **Release automation**: Added automated release scripts and GitHub Actions workflow
- **Testing**: Removed test requirements from release process for faster deployment
- **Documentation**: Updated release process documentation

## [0.1.0-beta.3] - 2025-07-16

### Changed
- **Git repository**: Cleaned up repository history and removed confidential documentation
- **Security**: Improved gitignore to prevent accidental commit of sensitive files

## [0.1.0-beta.2] - 2025-01-27

### Fixed
- **Certificate format compatibility**: Fixed private key format issues with rustls - now requires PKCS#8 DER format
- **Certificate generation**: Updated `generate_certs.sh` to generate proper DER format certificates for Flutter assets
- **Documentation improvements**: Completely restructured README to lead with substance, removed marketing fluff, and provided clear certificate format guidance

### Changed
- **Certificate loading**: Example app now loads `.der` format certificates instead of raw PEM files
- **Asset configuration**: Updated Flutter assets to include DER format certificate files
- **Documentation structure**: Streamlined README with beta warnings upfront and consolidated examples

## [0.1.0-beta.1] - 2025-07-15

### Added

#### 🚀 Core QUIC Support
- **Client endpoints**: Create QUIC client connections with `createClientEndpoint()`
- **Server endpoints**: Create QUIC server connections with `createServerEndpoint()`
- **TLS configuration**: Full support for TLS 1.3 with `serverConfigWithSingleCert()`
- **Stream operations**: Bidirectional and unidirectional streams for data transfer
- **Connection management**: Connection stats, RTT monitoring, and remote address info
- **Datagram support**: Unreliable message delivery for real-time applications

#### 🎯 Convenience API
- **HTTP-style interface**: Familiar GET/POST methods with QUIC performance
- **Connection pooling**: Automatic connection reuse and management
- **Retry logic**: Built-in exponential backoff for failed requests
- **Timeout protection**: Configurable timeouts for all operations
- **Configuration management**: Fine-grained control over connection parameters

#### 🔧 Developer Experience
- **Async/await support**: Full Flutter integration with Future-based APIs
- **Memory safety**: Rust ownership prevents memory leaks and corruption
- **Type safety**: Generated bindings with compile-time guarantees
- **Error handling**: Specific error types for different failure scenarios
- **Cross-platform**: Support for Android, iOS, Windows, macOS, and Linux

#### 📊 Production Features
- **Certificate loading**: Support for PEM/DER certificates and private keys
- **Connection migration**: Seamless WiFi ↔ cellular network switching
- **0-RTT connections**: Instant reconnection for repeat connections
- **Stream multiplexing**: Multiple independent streams over single connection
- **Flow control**: Built-in congestion control and bandwidth management

### Technical Details

#### API Coverage
- ✅ **Core API**: Complete 1:1 Quinn library mapping
- ✅ **Convenience API**: HTTP-style wrapper for common use cases
- ✅ **Client operations**: Full client-side QUIC functionality
- ✅ **Server operations**: Complete server-side QUIC implementation
- ✅ **Certificate management**: TLS certificate loading and validation

#### Performance Features
- **Head-of-line blocking elimination**: Independent stream processing
- **Reduced connection overhead**: Single connection replaces multiple TCP connections
- **Built-in security**: TLS 1.3 integration without additional handshake overhead
- **Network adaptation**: Dynamic adjustment to changing network conditions

#### Platform Support
- **Android**: API level 21+ with full feature support
- **iOS**: iOS 11+ with complete functionality
- **Desktop**: Windows 10+, macOS 10.14+, Linux (modern distributions)
- **Mobile-optimized**: Battery-aware optimizations for mobile platforms

### Known Limitations
- **Web platform**: Not supported (WebTransport may be added in future)
- **HTTP/3 semantics**: Raw QUIC transport only (HTTP/3 helpers planned)
- **Advanced TLS**: Custom certificate validation not yet implemented

### Dependencies
- `quinn = "0.11"` - Core QUIC implementation
- `flutter_rust_bridge = "2.11.1"` - Rust-Flutter integration
- `tokio` - Async runtime for Rust operations
- `rustls` - TLS 1.3 implementation

### Breaking Changes
- None (initial release)

---

**Note**: This is a beta release intended for testing and development. While the API is stable and feature-complete, it is not recommended for production use until the stable 1.0.0 release.

**Ready to test QUIC?** Check out the examples in the `example/` directory and let us know your feedback!
