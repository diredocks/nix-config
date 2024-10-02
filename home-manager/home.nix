# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./nvim.nix
  ];

  /*nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      inputs.alacritty-theme.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };*/

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.git = {
    enable = true;
    #userName = "diredocks";
    #userEmail = "26994007+diredocks@users.noreply.github.com";
  };


  home.packages = with pkgs;[
    qbittorrent
    inkscape
    burpsuite
    obs-studio
    #microsoft-edge
    brave
    fastfetch
    hugo
    wireshark
    dig
    unrar
    localsend
    telegram-desktop
    gcc
    ripgrep
    fd
    #wofi
    fzf
    #swaybg
    #waybar
    #pavucontrol
    firefox
    #libinput-gestures
    #papirus-icon-theme
    obsidian
    vlc
    wl-clipboard # for nvim clipboard support
  ];

  #home.file.".config/hypr" = {
  #  source = ./hyprland;
  #  recursive = true;
  #};

  #home.file.".config/waybar" = {
  #  source = ./waybar;
  #  recursive = true;
  #};

  #gtk = {
  #  enable = true;
  /*theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };*/
  /*cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };*/
  #};

  #home.pointerCursor = {
  #  package = pkgs.bibata-cursors;
  #  name = "Bibata-Modern-Ice";
  #};

  programs.zsh = {
    enable = true;
    shellAliases = {
      neofetch = "fastfetch";
    };
    initExtra = ''
      bindkey -s "^s" 'find . 2>/dev/null| fzf^M'
    '';
    plugins = [
      { name = "fzf-tab"; src = "${pkgs.zsh-fzf-tab}/share/fzf-tab"; }
      { name = "zsh-fzf-history-search"; src = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search"; }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [ "git" "ssh-agent" ];
      extraConfig = ''
        zstyle :omz:plugins:ssh-agent identities github_key
        zstyle :omz:plugins:ssh-agent lifetime 24h
      '';
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      import = [ pkgs.alacritty-theme.tokyo-night-storm ];
      window = {
        dimensions = { columns = 115; lines = 35; };
      };
      font = {
        size = 13;
        normal = {
          family = "JetBrains Mono";
        };
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-chinese-addons
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
