{
  inputs,
  lib,
  config,
  outputs,
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
    file
    fzf
    fastfetch
    fd
    ripgrep
    unrar
    bat
    just
  ];
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.alacritty-theme.overlays.default
    ];
  };
}
