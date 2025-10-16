# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    mutter = prev.mutter.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          (prev.fetchpatch {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4417.patch";
            hash = "sha256-VStKGQjwIVUgjljDokNURsr63DtqbDHBtV8nSnTupU8=";
          })
        ];
    });
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
    sing-box = prev.sing-box.overrideAttrs (old: rec {
      version = "1.12.10";
      src = prev.fetchFromGitHub {
        owner = "SagerNet";
        repo = "sing-box";
        tag = "v${version}";
        hash = "sha256-ZnpvE/x2+kKlKYuez1VaVx7qkybYhRTqfg7yorZpxfc=";
      };
      vendorHash = "sha256-D4nfi5PzcL9CcgLvm09DmF2Ws1o4wIH0zjgv1qDP7Nw=";
    });
    labwc = prev.labwc.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "labwc";
        repo = "labwc";
        rev = "5a50a02ba3e5d5a83f163ee603a2255779d941ab";
        hash = "sha256-laYjc4bIFrJdqqYuBdd9GE6RscIpyeKf08ixmJccj9U=";
      };
      buildInputs =
        (old.buildInputs or [])
        ++ [prev.wlroots_0_19];
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
