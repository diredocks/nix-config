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
    #   ./pixel_audio.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "hp-nixos";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.extraModprobeConfig = ''
  #  options snd-intel-dspcfg dsp_driver=4
  #  options snd-soc-avs ignore_fw_version=1
  #'';
  #boot.blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" "snd_sof_pci_intel_skl" ];

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
    users = {
      leo = import ../home-manager/home.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    unzip
    wget
    vim
    brightnessctl
    git
    htop
    libpcap
    patchelf
    tailscale
    #(alsa-ucm-conf.overrideAttrs (old: {
    #	wttsrc = (pkgs.fetchFromGitHub {
    #		owner = "WeirdTreeThing";
    #		repo = "chromebook-ucm-conf";
    #		rev = "4fd21f0550e036fa2916a6480dc46e325cf6b48e";
    #		hash = "sha256-5Eb+7dsU7+uhDCFuhUlx6EHgb/MRj6RfyQk7t1ZtAgw=";
    #      	       });
    #    installPhase = ''
    #	runHook preInstall
    #
    #	mkdir -p $out/share/alsa
    #	cp -r ucm ucm2 $out/share/alsa
    #
    #	mkdir -p $out/share/alsa/ucm2/conf.d
    #	cp -r $wttsrc/{hdmi,dmic}-common $wttsrc/avs/* $out/share/alsa/ucm2/conf.d
    #
    #	runHook postInstall
    #    '';
    #    }))
  ];

  #environment.sessionVariables = {
  #  ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf}/share/alsa/ucm2";
  #};

  system.stateVersion = "23.11";
}
