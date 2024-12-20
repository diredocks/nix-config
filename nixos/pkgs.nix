{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    unzip
    wget
    curl
    vim
    htop
    patchelf
  ];
}
