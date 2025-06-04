{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    cursorTheme = {
      name = "ComixCursors-Opaque-White";
      package = pkgs.comixcursors.Opaque_White;
    };
  };
}
