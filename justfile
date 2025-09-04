default: switch

boot:
  nixos-rebuild boot --flake . --sudo --ask-sudo-password

switch:
  nixos-rebuild switch --flake . --sudo --ask-sudo-password

switch-debug:
  nixos-rebuild switch --flake . --sudo --ask-sudo-password --show-trace --verbose

deploy host='pixelbook-nix' target='':
  nixos-rebuild switch --flake .#{{host}} --target-host {{target}} --sudo --ask-sudo-password 

deploy-debug host='pixelbook-nix' target='':
  nixos-rebuild switch --flake .#{{host}} --target-host {{target}} --sudo --ask-sudo-password --show-trace --verbose

update:
  nix flake update

gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old
  nix-collect-garbage --delete-old

fmt:
  nix fmt .

set-proxy host="tpm312" port="36176":
  #!/usr/bin/env bash
  set -euo pipefail
  proxy_ip=$(tailscale ip --4 {{host}})
  test -n "$proxy_ip"
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d
  echo -e '[Service]\nEnvironment="http_proxy=socks5://'${proxy_ip}':{{port}}"\nEnvironment="https_proxy=socks5://'${proxy_ip}':{{port}}"' | \
  sudo tee /run/systemd/system/nix-daemon.service.d/override.conf > /dev/null
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon

unset-proxy:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo rm -f /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
