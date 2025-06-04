{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.labwc = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    bemenu
    waybar
    swaybg
    wtype
    wmctrl
    xdotool
    libinput-gestures
    adwaita-icon-theme
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
      waylandFrontend = true;
    };
  };
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.labwc}/bin/labwc";
        user = "leo";
      };
      default_session = initial_session;
    };
  };
}
