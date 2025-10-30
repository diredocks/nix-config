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
  environment.systemPackages = with pkgs; [
    inputs.kwin-gestures.packages.${pkgs.system}.default
  ];
}
