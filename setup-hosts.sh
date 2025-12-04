#!/bin/bash

# Script to add the domain to /etc/hosts for local testing
DOMAIN_NAME="safandri.42.fr"

# Check if domain already exists in /etc/hosts
if grep -q "$DOMAIN_NAME" /etc/hosts; then
    echo "Domain $DOMAIN_NAME already exists in /etc/hosts"
else
    echo "Adding $DOMAIN_NAME to /etc/hosts..."
    echo "127.0.0.1 $DOMAIN_NAME" | sudo tee -a /etc/hosts
    echo "Domain added successfully!"
fi

echo "Current /etc/hosts entries for the domain:"
grep -i "$DOMAIN_NAME" /etc/hosts || echo "No entries found"