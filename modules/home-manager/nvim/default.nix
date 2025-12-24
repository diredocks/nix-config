{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.lazyvim = {
    enable = true;
    extraPackages = with pkgs; [
      # LazyVim
      stylua
      tree-sitter
      # Telescope
      ripgrep
      # lazygit
      lazygit
      wl-clipboard # for nvim clipboard support
      fd
      gcc
    ];
    configFiles = ./lua;
    extras = {
      lang.typescript.enable = true;
    };
  };
  # Set default editor
  home.sessionVariables.EDITOR = "nvim";
}
