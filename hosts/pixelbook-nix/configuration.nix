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
    ./hardware/hardware-acc-gpu.nix
    ../../modules/nixos/devices.nix
    ../../modules/nixos/pkgs.nix
    ../../modules/nixos/services
    ../../modules/nixos/desktop
  ];

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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
