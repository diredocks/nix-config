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
  };
}
