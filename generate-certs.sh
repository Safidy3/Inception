#!/bin/bash

# Script to generate SSL certificates for the domain
DOMAIN_NAME="safandri.42.fr"
CERTS_DIR="./srcs/certs"

# Create certs directory if it doesn't exist
mkdir -p "$CERTS_DIR"

echo "Generating SSL certificates for $DOMAIN_NAME..."

# Generate self-signed certificate (non-interactive)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERTS_DIR/privkey.pem" \
    -out "$CERTS_DIR/fullchain.pem" \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=$DOMAIN_NAME"

echo "Certificates generated successfully in $CERTS_DIR/"
echo "Files created:"
echo "  - privkey.pem (private key)"
echo "  - fullchain.pem (certificate)"
ls -la "$CERTS_DIR/"