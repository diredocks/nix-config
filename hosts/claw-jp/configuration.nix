# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  sshKeys = import ../../secrets/ssh-keys-pub.nix;
in {
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
    {
      age.secrets."xray_claw-jp.json".file = ../../secrets/xray_claw-jp.json;
    }
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
        sshKeys.users.leo_probook-nix
      ];
    };
    root = {
      openssh.authorizedKeys.keys = [
        sshKeys.users.leo_probook-nix
      ];
    };
  };
  services.openssh.settings.PermitRootLogin = "yes";

  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
    xray # cli
  ];
  services.xray = {
    enable = true;
    settingsFile = config.age.secrets."xray_claw-jp.json".path;
  };
  # restart xray when config changed
  systemd.services."xray".restartTriggers = ["${config.age.secrets."xray_claw-jp.json".file}"];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
