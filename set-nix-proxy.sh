sudo mkdir /run/systemd/system/nix-daemon.service.d/
cat << EOF >/run/systemd/system/nix-daemon.service.d/override.conf
[Service]
Environment="https_proxy=http://100.85.129.127:10086"
EOF
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
