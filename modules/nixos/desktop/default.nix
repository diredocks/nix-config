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
    ./fcitx.nix
  ];
}
