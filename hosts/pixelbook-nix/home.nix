{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager/nvim
    ../../modules/home-manager/zsh.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/pkgs.nix
    ../../modules/home-manager/gtk.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
