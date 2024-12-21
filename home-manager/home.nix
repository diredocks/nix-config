{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nvim
    ./zsh.nix
    ./alacritty.nix
    ./vscode.nix
    ./pkgs.nix
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
