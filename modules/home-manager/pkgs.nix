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
        "--enable-features=TouchpadOverscrollHistoryNavigation"
      ];
    })
    hugo
    wireshark
    telegram-desktop
    firefox
    obsidian
    vlc
    remmina
    # zed-editor
    claude-code
    thunderbird
    hmcl
  ];
}
