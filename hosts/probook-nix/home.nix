{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/kwin
    ../../modules/home-manager/nvim
    ../../modules/home-manager/pkgs.nix
    ../../modules/home-manager/foot.nix
    ../../modules/home-manager/vscode.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
