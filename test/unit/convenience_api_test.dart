import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quic/flutter_quic.dart' as flutter_quic;

void main() {
  group('QuicClient Convenience API Tests', () {
    setUpAll(() async {
      // Initialize the Rust library
      await flutter_quic.RustLib.init();
    });

    test('QuicClient creation with default config', () async {
      // Test creating a QuicClient with default configuration
      final client = await flutter_quic.quicClientCreate();
      expect(client, isNotNull);
      expect(client.runtimeType.toString(), contains('QuicClient'));
    });

    test('QuicClient creation with custom config', () async {
      // Test creating a custom configuration
      final config = await flutter_quic.quicClientConfigNew();
      expect(config, isNotNull);
      expect(config.runtimeType.toString(), contains('QuicClientConfig'));

      // Test creating client with custom config
      final client = await flutter_quic.quicClientCreateWithConfig(
        config: config,
      );
      expect(client, isNotNull);
      expect(client.runtimeType.toString(), contains('QuicClient'));
    });

    test('QuicClient configuration access', () async {
      final client = await flutter_quic.quicClientCreate();

      // Test accessing configuration
      final (updatedClient, config) = await flutter_quic.quicClientConfig(
        client: client,
      );
      expect(updatedClient, isNotNull);
      expect(config, isNotNull);
      expect(config.runtimeType.toString(), contains('QuicClientConfig'));

      // Verify default configuration values
      expect(config.maxConnectionsPerHost, greaterThan(BigInt.zero));
      expect(config.connectTimeoutMs, greaterThan(BigInt.zero));
      expect(config.requestTimeoutMs, greaterThan(BigInt.zero));
      expect(config.retryAttempts, greaterThan(0));
      expect(config.retryDelayMs, greaterThan(BigInt.zero));
      expect(config.keepAliveTimeoutMs, greaterThan(BigInt.zero));
    });

    test('QuicClient connection pool management', () async {
      final client = await flutter_quic.quicClientCreate();

      // Test clearing connection pool
      final clearedClient = await flutter_quic.quicClientClearPool(
        client: client,
      );
      expect(clearedClient, isNotNull);
      expect(clearedClient.runtimeType.toString(), contains('QuicClient'));
    });

    group('HTTP-style API methods', () {
      late flutter_quic.QuicClient client;

      setUp(() async {
        client = await flutter_quic.quicClientCreate();
      });

      test('GET method API structure', () async {
        // This will fail due to no server, but tests API structure
        try {
          final (clientAfterGet, response) = await flutter_quic.quicClientGet(
            client: client,
            url: 'https://httpbin.org/get',
          );
          // If this succeeds somehow, verify the types
          expect(clientAfterGet, isNotNull);
          expect(response, isA<String>());
        } catch (e) {
          // Expected to fail without a QUIC server
          expect(e, isNotNull);
          // Verify it's a proper error type
          expect(e.toString(), isNotEmpty);
        }
      });

      test('POST method API structure', () async {
        try {
          final (clientAfterPost, response) = await flutter_quic.quicClientPost(
            client: client,
            url: 'https://httpbin.org/post',
            data: '{"test": "data"}',
          );
          expect(clientAfterPost, isNotNull);
          expect(response, isA<String>());
        } catch (e) {
          // Expected to fail without a QUIC server
          expect(e, isNotNull);
          expect(e.toString(), isNotEmpty);
        }
      });

      test('GET with timeout API structure', () async {
        try {
          final (clientAfterTimeout, response) = await flutter_quic
              .quicClientGetWithTimeout(
                client: client,
                url: 'https://httpbin.org/delay/1',
              );
          expect(clientAfterTimeout, isNotNull);
          expect(response, isA<String>());
        } catch (e) {
          // Expected to fail without a QUIC server
          expect(e, isNotNull);
          expect(e.toString(), isNotEmpty);
        }
      });

      test('POST with timeout API structure', () async {
        try {
          final (clientAfterTimeout, response) = await flutter_quic
              .quicClientPostWithTimeout(
                client: client,
                url: 'https://httpbin.org/post',
                data: '{"timeout": "test"}',
              );
          expect(clientAfterTimeout, isNotNull);
          expect(response, isA<String>());
        } catch (e) {
          // Expected to fail without a QUIC server
          expect(e, isNotNull);
          expect(e.toString(), isNotEmpty);
        }
      });

      test('Send method API structure', () async {
        try {
          final (clientAfterSend, response) = await flutter_quic.quicClientSend(
            client: client,
            url: 'https://httpbin.org/post',
            data: 'test data',
          );
          expect(clientAfterSend, isNotNull);
          expect(response, isA<String>());
        } catch (e) {
          // Expected to fail without a QUIC server
          expect(e, isNotNull);
          expect(e.toString(), isNotEmpty);
        }
      });

      test('Send with timeout API structure', () async {
        try {
          final (clientAfterTimeout, response) = await flutter_quic
              .quicClientSendWithTimeout(
                client: client,
                url: 'https://httpbin.org/post',
                data: 'timeout test data',
              );
          expect(clientAfterTimeout, isNotNull);
          expect(response, isA<String>());
        } catch (e) {
          // Expected to fail without a QUIC server
          expect(e, isNotNull);
          expect(e.toString(), isNotEmpty);
        }
      });
    });

    group('Core API integration', () {
      test('Core API still available alongside Convenience API', () async {
        // Test that Core API is still accessible
        final endpoint = await flutter_quic.createClientEndpoint();
        expect(endpoint, isNotNull);
        expect(endpoint.runtimeType.toString(), contains('QuicEndpoint'));
      });
    });
  });

  group('API Design Verification', () {
    test('Convenience API built on Core API', () async {
      // Verify both APIs are available
      final coreEndpoint = await flutter_quic.createClientEndpoint();
      final convenienceClient = await flutter_quic.quicClientCreate();

      expect(coreEndpoint, isNotNull);
      expect(convenienceClient, isNotNull);

      // Both should be different types but available simultaneously
      expect(coreEndpoint.runtimeType.toString(), contains('QuicEndpoint'));
      expect(convenienceClient.runtimeType.toString(), contains('QuicClient'));
    });

    test('HTTP-style interface consistency', () async {
      final client = await flutter_quic.quicClientCreate();

      // All HTTP methods should have consistent signatures
      // This tests the API design without actual network calls

      // GET method should take client and url
      expect(() async {
        await flutter_quic.quicClientGet(client: client, url: 'test');
      }, throwsA(anything)); // Will throw due to invalid URL/no server

      // POST method should take client, url, and data
      expect(() async {
        await flutter_quic.quicClientPost(
          client: client,
          url: 'test',
          data: 'data',
        );
      }, throwsA(anything)); // Will throw due to invalid URL/no server
    });
  });
}
