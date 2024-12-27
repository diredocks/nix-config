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
    ./hardware/boot.nix
    ./hardware/hardware-configuration.nix
    ./hardware/audio.nix
    ./hardware/keyboard.nix
    ../../nixos/devices.nix
    ../../nixos/pkgs.nix
    ../../nixos/services
    ../../nixos/desktop
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  networking.hostName = "pixelbook-nix";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    leo = {
      initialPassword = "1";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
