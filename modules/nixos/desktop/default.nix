{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./kde.nix
  ];
}
