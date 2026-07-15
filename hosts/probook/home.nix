{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.lazyvim.homeManagerModules.default
    ../../modules/home-manager
    ../../modules/home-manager/inputactions
    ../../modules/home-manager/nvim
    ../../modules/home-manager/pkgs.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/llm-agents.nix
    ../../modules/home-manager/android-studio.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
