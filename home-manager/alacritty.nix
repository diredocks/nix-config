{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [pkgs.alacritty-theme.tokyo_night_storm];
      };
      window = {
        dimensions = {
          columns = 115;
          lines = 35;
        };
      };
      font = {
        size = 15;
        normal = {
          family = "ComicShannsMono Nerd Font";
        };
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
