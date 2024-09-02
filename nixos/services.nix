{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.leo.extraGroups = [ "libvirtd" ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  services.tailscale.enable = true;

  services.flatpak.enable = true;

  #powerManagement.powertop.enable = true;
  #services.thermald.enable = true;
  #services.auto-cpufreq.enable = true;
  #services.auto-cpufreq.settings = {
  #  battery = {
  #    governor = "powersave";
  #    turbo = "never";
  #  };
  #  charger = {
  #    governor = "performance";
  #    turbo = "auto";
  #  };
  #};

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  #services.blueman.enable = true;

  #programs.hyprland.enable = true;
  #services.xserver.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager = {
  #  autoLogin.enable = true;
  #  autoLogin.user = "leo";
  #};

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "leo";
  };
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      source-code-pro
      jetbrains-mono
      ubuntu_font_family
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono" ];
        sansSerif = [ "Ubuntu" "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans" ];
        serif = [ "Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif" ];
      };
    };
  };
}
