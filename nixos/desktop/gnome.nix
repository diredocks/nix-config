{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "leo";
  };
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
    gnome-terminal
  ];
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.kimpanel
  ];
  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
  };
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };
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
}
