default: boot

boot:
  nixos-rebuild boot --flake . --sudo --ask-sudo-password

switch:
  nixos-rebuild switch --flake . --sudo --ask-sudo-password

deploy:
  nix run github:serokell/deploy-rs -- -s .

update:
  nix flake update

gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old
  nix-collect-garbage --delete-old

fmt:
  nix fmt .

set-proxy-local:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d
  echo -e '[Service]\nEnvironment="http_proxy=http://127.0.0.1:36176"\nEnvironment="https_proxy=http://127.0.0.1:36176"' | \
  sudo tee /run/systemd/system/nix-daemon.service.d/override.conf > /dev/null
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon

set-proxy:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d
  echo -e '[Service]\nEnvironment="http_proxy=http://192.168.31.227:36176"\nEnvironment="https_proxy=http://192.168.31.227:36176"' | \
  sudo tee /run/systemd/system/nix-daemon.service.d/override.conf > /dev/null
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon

unset-proxy:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo rm -f /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
