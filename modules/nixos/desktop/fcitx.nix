{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        fcitx5-rime
        rime-data
      ];
      waylandFrontend = true;
    };
  };
}
