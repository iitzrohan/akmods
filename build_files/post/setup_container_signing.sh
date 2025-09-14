#!/bin/bash

set "${CI:+-x}" -euo pipefail

# Temporary script to configure container signing for ghcr.io/iitzrohan

echo "Checking prerequisites..."

# Ensure key and policy files are present
if [[ ! -f /tmp/fedora-atomic.pub ]]; then
  echo "ERROR: /tmp/fedora-atomic.pub not found."
  exit 1
fi

if [[ ! -f /tmp/policy.json ]]; then
  echo "ERROR: /tmp/policy.json not found."
  exit 1
fi

echo "Copying fedora-atomic.pub to /etc/pki/containers/fedora-atomic.pub..."
mkdir -p /etc/pki/containers
cp /tmp/fedora-atomic.pub /etc/pki/containers/fedora-atomic.pub

echo "Setting up container signing configuration for ghcr.io/iitzrohan..."

# 1. Write registry configuration
echo "Writing registry configuration to /etc/containers/registries.d/fedora-atomic.yaml..."
mkdir -p /etc/containers/registries.d
tee /etc/containers/registries.d/fedora-atomic.yaml > /dev/null << 'EOF'
docker:
  ghcr.io/iitzrohan:
    use-sigstore-attachments: true
EOF

# 2. Write policy configuration
echo "Writing policy configuration to /etc/containers/policy.json..."
mkdir -p /etc/containers
cp /tmp/policy.json /etc/containers/policy.json

echo "Container signing setup complete!"