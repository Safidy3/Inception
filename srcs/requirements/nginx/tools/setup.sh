#!/bin/bash
set -e

# Ensure cert directory exists
mkdir -p /etc/nginx/certs

# Copy user-provided certificates from mounted volume (in compose)
if [ -d /certs ] && [ -f /certs/fullchain.pem ] && [ -f /certs/privkey.pem ]; then
    cp /certs/fullchain.pem /etc/nginx/certs/fullchain.pem
    cp /certs/privkey.pem /etc/nginx/certs/privkey.pem
    echo "Using existing certificates"
else
    echo "No certificates found, generating self-signed certificates..."
    # Generate self-signed certificate for the domain
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/certs/privkey.pem \
        -out /etc/nginx/certs/fullchain.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=${DOMAIN_NAME}"
    echo "Generated self-signed certificates for ${DOMAIN_NAME}"
fi

# Substitute environment variables in nginx config
envsubst '${DOMAIN_NAME}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp
mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf

echo "Starting NGINX..."
exec "$@"
