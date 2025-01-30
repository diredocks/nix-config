{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  xdg.configFile."kwingestures.yml".source = ./kwingestures.yml;
}
