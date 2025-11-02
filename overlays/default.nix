# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # wrangler = inputs.wrangler.packages.${final.system}.default;
    xray = prev.xray.overrideAttrs (old: rec {
      version = "25.4.30";
      src = prev.fetchFromGitHub {
        owner = "XTLS";
        repo = "Xray-core";
        rev = "v${version}";
        hash = "sha256-qhZgf+HQXfmWNnwjgDZwcs1WR77HoqRXd4VZEwFKPWs=";
      };
      vendorHash = "sha256-4kAU+8YXrJOu1wyiuFuPWT0dHI3WzlXY9s7NKyI9r5U=";
    });
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
  };
}
