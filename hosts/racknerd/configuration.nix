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
    ../../modules/nixos/services/sing-box.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  networking.hostName = "racknerd";
  networking.firewall.enable = false;
  services.resolved.enable = false;
  networking.useDHCP = false;
  networking.nameservers = [
    "1.1.1.1"
  ];
  systemd.network.enable = true;
  systemd.network.networks.eth0 = {
    networkConfig.DHCP = "ipv4";
    matchConfig.Name = "eth0";
  };

  time.timeZone = "America/Denver";
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
  };

  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
    sing-box
  ];

  services.sing-box = {
    enable = true;
    settingsFile = config.age.secrets.racknerd-sb-conf.path;
  };
  systemd.services.sing-box.restartTriggers = ["${config.age.secrets.racknerd-sb-conf.file}"];
  age.secrets.racknerd-sb-conf.file = ../../secrets/racknerd-sb-config.json;

  services.openssh.ports = [9283];

  system.stateVersion = "25.05";
}
