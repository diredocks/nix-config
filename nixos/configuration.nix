{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nix.nix
    ./services.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "hp-nixos";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.extraEntries."arch.conf" = ''
    title Archlinux
    linux /vmlinuz-linux-lts
    initrd /initramfs-linux-lts.img
    options root=UUID=f6215e55-ec45-48d7-b403-df87b39efcfe rw
  '';

  programs.zsh.enable = true;

  users.users = {
    leo = {
      initialPassword = "1";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
    };
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    useGlobalPkgs = true;
    users = {
      leo = import ../home-manager/home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    unzip
    wget
    vim
    git
    htop
    patchelf
    tailscale
  ];

  system.stateVersion = "23.11";
}
