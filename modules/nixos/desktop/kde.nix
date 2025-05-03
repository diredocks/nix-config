{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "leo";
  };
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-rime
        rime-data
      ];
      plasma6Support = true;
      waylandFrontend = true;
    };
  };
  environment.systemPackages = with pkgs; [
    inputs.kwin-gestures.packages.${pkgs.system}.default
  ];
}
