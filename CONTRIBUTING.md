# Contributing to Flutter QUIC

Thank you for your interest in contributing to Flutter QUIC! This document provides guidelines and information for contributors.

## Code of Conduct

This project follows the [Flutter Code of Conduct](https://github.com/flutter/flutter/blob/master/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Development Setup

### Prerequisites

- Flutter SDK (latest stable version)
- Rust toolchain (1.70 or later)
- Android SDK (for Android development)
- Xcode (for iOS/macOS development)
- Visual Studio or Build Tools (for Windows development)

### Setup Steps

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter_quic.git
cd flutter_quic
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Install Rust dependencies:
```bash
cd rust
cargo build
cd ..
```

4. Generate Flutter-Rust bridge bindings:
```bash
flutter_rust_bridge_codegen generate
```

5. Run tests to verify setup:
```bash
flutter test
cd rust && cargo test
```

## Development Principles

### 🚫 NO PLACEHOLDERS Policy

This project has a strict **NO PLACEHOLDERS** policy. All code must be production-ready:

- ❌ No `todo!()` macros in Rust
- ❌ No `// TODO:` comments  
- ❌ No `unimplemented!()` calls
- ❌ No dummy return values like `Ok(())` without real logic
- ❌ No mock data instead of actual API calls
- ❌ No generic error messages like "Something went wrong"

### ✅ Required Patterns

- Complete function implementations
- Specific error handling with proper error types
- Real API calls to Quinn library
- Actual network operations
- Proper resource management and cleanup

## Architecture Guidelines

### Two-Tier API Design

1. **Core API** (`lib/src/core/`): 1:1 mapping to Quinn Rust library
   - Every Quinn public method must be exposed
   - Direct async bridging: `Future<T>` in Rust → `Future<T>` in Dart
   - Use `#[frb(opaque)]` for complex Rust types
   - Implement proper `Drop` traits for cleanup

2. **Convenience API** (`lib/src/convenience/`): High-level abstractions
   - Built on top of Core API
   - HTTP-style interface for common use cases
   - Connection pooling and retry logic
   - Simple configuration options

### File Organization

```
lib/src/
├── core/          # Core API implementations
├── convenience/   # Convenience API implementations  
├── errors/        # Error type definitions
└── models/        # Data models and types

rust/src/
├── core/          # Core Quinn wrappers
├── convenience/   # High-level client implementations
├── errors/        # Error handling
└── models/        # Rust data structures
```

## Testing Standards

### Required Tests

1. **Unit Tests**: All public methods and error paths
2. **Integration Tests**: Real network communication with certificates
3. **Performance Tests**: Within 5% of native Quinn performance
4. **Platform Tests**: All supported platforms (Android, iOS, Windows, macOS, Linux)

### Test Organization

```
test/
├── unit/          # Unit tests for individual components
├── integration/   # Integration tests with real networking
└── performance/   # Performance benchmarks
```

### Running Tests

```bash
# Dart tests
flutter test

# Rust tests  
cd rust && cargo test

# Integration tests (requires test server)
flutter test test/integration/

# Performance tests
flutter test test/performance/
```

## Code Style

### Dart Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` for formatting
- Use `dart analyze` for linting
- Document all public APIs with dartdoc comments

### Rust Code Style

- Follow standard Rust formatting with `cargo fmt`
- Use `cargo clippy` for linting
- Document all public APIs with `///` comments
- Use meaningful error types, not `Box<dyn Error>`

## Submitting Changes

### Pull Request Process

1. **Fork** the repository and create a feature branch
2. **Write tests** for your changes before implementing
3. **Implement** your changes following the project principles
4. **Test** thoroughly on multiple platforms
5. **Document** all public APIs and behavior changes
6. **Submit** a pull request with a clear description

### Pull Request Requirements

- [ ] All tests pass on all platforms
- [ ] Code follows project style guidelines
- [ ] Public APIs are documented
- [ ] No placeholders or TODO items
- [ ] Performance impact is acceptable
- [ ] Breaking changes are clearly marked

### Commit Message Format

Use conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

Examples:
- `feat(core): add bidirectional stream support`
- `fix(convenience): handle connection timeout correctly`
- `docs(readme): update installation instructions`

## Issue Reporting

### Bug Reports

Please include:
- Flutter version and platform
- Rust version
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs or stack traces

### Feature Requests

Please include:
- Use case description
- Proposed API design
- Performance considerations
- Platform compatibility

## Review Process

All contributions go through code review:

1. **Automated checks**: CI runs tests and linting
2. **Manual review**: Maintainers review code quality and design
3. **Testing**: Changes are tested on multiple platforms
4. **Documentation**: API documentation is reviewed
5. **Performance**: Performance impact is evaluated

## Getting Help

- **Documentation**: Check the `docs/` directory
- **Discussions**: Use GitHub Discussions for questions
- **Issues**: Use GitHub Issues for bugs and feature requests
- **Chat**: Join our community chat (link TBD)

## Recognition

Contributors will be:
- Listed in release notes for significant contributions
- Added to the `AUTHORS` file
- Mentioned in documentation where appropriate

Thank you for contributing to Flutter QUIC! 🚀 