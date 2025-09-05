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
    ./hardware/hardware-configuration.nix
    ./hardware/boot.nix
    ../../modules/nixos/devices.nix
    ../../modules/nixos/pkgs.nix
    ../../modules/nixos/services
    ../../modules/nixos/desktop
  ];

  networking.hostName = "probook-nix";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  boot.tmp.useTmpfs = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"]; # For building aarch64 images

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {
    leo = {
      initialPassword = "1";
      isNormalUser = true;
      extraGroups = ["wheel" "dialout"];
    };
  };

  system.stateVersion = "23.05";
}
