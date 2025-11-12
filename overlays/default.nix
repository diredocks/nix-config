# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  modifications = final: prev: {
    # wrangler = inputs.wrangler.packages.${final.system}.default;
    vimPlugins = prev.vimPlugins.extend (
      final': prev': {
        nvim-treesitter = prev'.nvim-treesitter.overrideAttrs (old: rec {
          src = inputs.nvim-treesitter;
          name = "${old.pname}-${src.rev}";
          postPatch = "";
          # ensure runtime queries get linked to RTP (:TSInstall does this too)
          buildPhase = "
              mkdir -p $out/queries
              cp -a $src/runtime/queries/* $out/queries
            ";
          doCheck = false;
          nvimSkipModules = ["nvim-treesitter._meta.parsers"];
        });
        nvim-treesitter-textobjects = prev'.nvim-treesitter-textobjects.overrideAttrs (old: rec {
          src = inputs.nvim-treesitter-textobjects;
          name = "${old.pname}-${src.rev}";
          doCheck = false;
        });
      }
    );
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
