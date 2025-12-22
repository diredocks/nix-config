{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
