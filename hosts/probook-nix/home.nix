{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home-manager/kwin
    ../../home-manager/nvim
    ../../home-manager/zsh.nix
    ../../home-manager/alacritty.nix
    ../../home-manager/ghostty.nix
    ../../home-manager/vscode.nix
    ../../home-manager/pkgs.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
