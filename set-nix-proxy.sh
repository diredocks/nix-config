#!/bin/bash

# Define variables
SERVICE_DIR="/run/systemd/system/nix-daemon.service.d"
OVERRIDE_FILE="${SERVICE_DIR}/override.conf"

# Retrieve the proxy IP dynamically
PROXY_IP=$(tailscale ip --4 tpm312)

# Check if the proxy IP was retrieved successfully
if [ -z "$PROXY_IP" ]; then
  echo "Error: Failed to retrieve proxy IP using 'tailscale ip --4 tpm312'."
  exit 1
fi

# Define the proxy URL
PROXY_URL="http://${PROXY_IP}:36178"

# Create the service override directory if it doesn't exist
mkdir -p "$SERVICE_DIR"

# Create the override configuration file
cat << EOF > "$OVERRIDE_FILE"
[Service]
Environment="https_proxy=$PROXY_URL"
EOF

# Reload systemd to apply the changes
systemctl daemon-reload

# Restart the service to apply the new configuration
systemctl restart nix-daemon

# Print a success message
echo "Proxy configuration applied successfully to nix-daemon with proxy IP: $PROXY_IP"
