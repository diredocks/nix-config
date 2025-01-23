mkdir /run/systemd/system/nix-daemon.service.d/
cat << EOF >/run/systemd/system/nix-daemon.service.d/override.conf
[Service]
Environment="https_proxy=http://100.121.16.24:36178"
EOF
systemctl daemon-reload
systemctl restart nix-daemon
