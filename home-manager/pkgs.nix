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
    (brave.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-features=AcceleratedVideoDecodeLinuxGL"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
        "--enable-features=TouchpadOverscrollHistoryNavigation"
      ];
    })
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
    remmina
  ];
}
