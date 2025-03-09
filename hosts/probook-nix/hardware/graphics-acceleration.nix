{
  inputs,
  lib,
  config,
  pkgs,
  ...
}
: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      vaapiVdpau
      mesa.drivers
    ];
  };
}
