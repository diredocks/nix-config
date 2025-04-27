{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      source-code-pro
      jetbrains-mono
      ubuntu_font_family
      nerd-fonts.jetbrains-mono
      nerd-fonts.comic-shanns-mono
      adwaita-fonts
    ];
    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono"];
        sansSerif = ["Adwaita Sans" "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans"];
        serif = ["Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif"];
      };
      useEmbeddedBitmaps = true;
    };
  };
}
