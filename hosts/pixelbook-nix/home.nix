{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager
    # ../../modules/home-manager/nvim
    # ../../modules/home-manager/pkgs.nix
    ../../modules/home-manager/gtk.nix
    ../../modules/home-manager/foot.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  home.packages = with pkgs; [
    (brave.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-features=AcceleratedVideoDecodeLinuxGL"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--disable-features=GlobalShortcutsPortal"
      ];
    })
    zed-editor
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
