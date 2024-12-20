{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    qbittorrent
    inkscape
    obs-studio
    brave
    fastfetch
    hugo
    wireshark
    dig
    unrar
    localsend
    telegram-desktop
    gcc
    ripgrep
    fd
    fzf
    firefox
    obsidian
    vlc
  ];
}
