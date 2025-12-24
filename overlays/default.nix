# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  modifications = final: prev: {
    # wrangler = inputs.wrangler.packages.${final.system}.default;
    strawberry = prev.strawberry.overrideAttrs (old: rec {
      src = prev.fetchFromGitHub {
        owner = "diredocks";
        repo = "strawberryNE";
        rev = "4d79f85ea212aa7267f5c662233ac9f59da2f67f";
        hash = "sha256-zObmN1MlVLg7H+otBarCwXFykcCdgfBLvLFddbnCIgI=";
      };
    });
    hmcl = prev.hmcl.overrideAttrs (old: rec {
      src = prev.fetchurl {
        url = "https://github.com/HMCL-dev/HMCL/releases/download/v3.7.5/HMCL-3.7.5.jar";
        hash = "sha256-C3/+XsUJJmyLyqnXCWMbaU2ZvE6uZVyy/2f9GykB0QI=";
      };
    });
  };
}
