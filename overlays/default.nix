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
  };
}
