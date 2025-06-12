default: switch

boot:
  nixos-rebuild boot --flake . --use-remote-sudo

switch:
  nixos-rebuild switch --flake . --use-remote-sudo

switch-debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

deploy host='pixelbook-nix' target='':
  nixos-rebuild switch --flake .#{{host}} --target-host {{target}} --use-remote-sudo

deploy-debug host='pixelbook-nix' target='':
  nixos-rebuild switch --flake .#{{host}} --target-host {{target}} --use-remote-sudo --show-trace --verbose

up:
  nix flake update

gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

set-proxy host="tpm312" port="36178":
  #!/usr/bin/env bash
  set -euo pipefail
  proxy_ip=$(tailscale ip --4 {{host}})
  test -n "$proxy_ip"
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d
  echo -e '[Service]\nEnvironment="http_proxy=http://'${proxy_ip}':{{port}}"\nEnvironment="https_proxy=https://'${proxy_ip}':36178"' | \
  sudo tee /run/systemd/system/nix-daemon.service.d/override.conf > /dev/null
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon

unset-proxy:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo rm -f /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
