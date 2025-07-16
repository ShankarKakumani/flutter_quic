#!/bin/bash

# Generate self-signed certificates for QUIC server demo
# This creates certificates that work for localhost testing

echo "🔐 Generating self-signed certificates for QUIC demo..."

# Create certificates directory
mkdir -p certs
cd certs

# Generate private key in PKCS#8 format (required by rustls)
openssl genpkey -algorithm RSA -out server.key

# Generate certificate signing request
openssl req -new -key server.key -out server.csr -subj "/C=US/ST=Demo/L=Demo/O=FlutterQUIC/CN=localhost"

# Generate self-signed certificate valid for 365 days
openssl x509 -req -in server.csr -signkey server.key -out server.crt -days 365 -extensions v3_req -extfile <(cat <<EOF
[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF
)

# Convert private key to DER format for Flutter assets (binary loading)
openssl pkey -in server.key -outform DER -out server.key.der

# Convert certificate to DER format for Flutter assets  
openssl x509 -in server.crt -outform DER -out server.crt.der

# Create combined PEM file for traditional use
cat server.crt > server.pem
cat server.key >> server.pem

echo "✅ Certificates generated successfully!"
echo "📁 Files created in certs/ directory:"
echo "  - server.key (private key - PEM format)"
echo "  - server.key.der (private key - DER format for Flutter)"
echo "  - server.crt (certificate - PEM format)"
echo "  - server.crt.der (certificate - DER format for Flutter)"
echo "  - server.pem (combined PEM for easy use)"
echo ""
echo "🚀 Ready to run QUIC server with these certificates!"

# Clean up CSR file
rm server.csr 