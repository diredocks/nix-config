# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/profiles/headless.nix"
    "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
    ./hardware/boot.nix
    ./hardware/disko.nix
    ./hardware/hardware-configuration.nix
    ../../modules/nixos/pkgs.nix
    ../../modules/nixos/services/nix.nix
    ../../modules/nixos/services/sshd.nix
    ../../modules/nixos/services/shell.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  networking.hostName = "claw-jp";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    leo = {
      initialPassword = "1";
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvNNmgJ5neYYp6dST9dzw1wttCnhc9VQ5Nls2DUidSZ/DzSGy0/eCqX6oj9B78YugS6xRmovRpvKyY4ihi76R7aLrj50jgRd+8MFMvCtac/QaOjw4/LXPWuY0/OW118NS995X6og/6SQALsQkrgnjUA6IFmt1Zb6ZbQNg7pUGg/3KIMuLXJWWlCAtnB7SfWdY4PwMZg6ftLrzmS4nDJp58ygRkgnhbaGKWC384n1sgsepq1OyGS83GQAd636I/wl2jl3nnEfxfyWiTpxQ//zoTpCZ4lAEiRa9fCumnnPnM7Co9DEofrFgXa3A/bEkHz2sM4TWM42m/6kk5A0v/Oy/eTVKNAzVaHAC4Ai6pwwnK98ETWf6fZ7YoEVbmEmTdPiFkhlOIF7On54OdTPz6c6QDilMb6ncWJS6mP7NK2/ffNaU7d+ttRxxGvO+h5NywN3/+ykP7erGT4mHZljecHKDnPILHTx7sVRNox/uJ0RZDHzkLPX1nB3uwKyg/zL1HTRU= leo@hp-laptop"
      ];
    };
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvNNmgJ5neYYp6dST9dzw1wttCnhc9VQ5Nls2DUidSZ/DzSGy0/eCqX6oj9B78YugS6xRmovRpvKyY4ihi76R7aLrj50jgRd+8MFMvCtac/QaOjw4/LXPWuY0/OW118NS995X6og/6SQALsQkrgnjUA6IFmt1Zb6ZbQNg7pUGg/3KIMuLXJWWlCAtnB7SfWdY4PwMZg6ftLrzmS4nDJp58ygRkgnhbaGKWC384n1sgsepq1OyGS83GQAd636I/wl2jl3nnEfxfyWiTpxQ//zoTpCZ4lAEiRa9fCumnnPnM7Co9DEofrFgXa3A/bEkHz2sM4TWM42m/6kk5A0v/Oy/eTVKNAzVaHAC4Ai6pwwnK98ETWf6fZ7YoEVbmEmTdPiFkhlOIF7On54OdTPz6c6QDilMb6ncWJS6mP7NK2/ffNaU7d+ttRxxGvO+h5NywN3/+ykP7erGT4mHZljecHKDnPILHTx7sVRNox/uJ0RZDHzkLPX1nB3uwKyg/zL1HTRU= leo@hp-laptop"
      ];
    };
  };
  services.openssh.PermitRootLogin = "yes";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
