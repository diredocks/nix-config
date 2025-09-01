{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/profiles/headless.nix"
    "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
    #./hardware/boot.nix
    #./hardware/disko.nix
    ./hardware/hardware-configuration.nix
    ./hardware/sd-image.nix
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

  networking.hostName = "tpm312";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
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

  services.openssh.settings.PermitRootLogin = "yes";

  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  system.stateVersion = "25.05";
}
