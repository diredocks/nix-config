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
  };


  home.packages = with pkgs;[
    qbittorrent
    inkscape
    obs-studio
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
    fzf
    firefox
    obsidian
    vlc
    wl-clipboard # for nvim clipboard support
  ];

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
      plugins = [ "git" ];
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [ pkgs.alacritty-theme.tokyo_night_storm ];
      };
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
