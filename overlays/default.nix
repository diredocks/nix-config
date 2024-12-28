# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
      kwin = kprev.kwin.overrideAttrs (previousAttrs: {
        patches =
          previousAttrs.patches
          ++ [
            ./kwin/touchpad_gesture.patch
          ];
      });
    });
    zsh-fzf-tab = prev.zsh-fzf-tab.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs or [] ++ [ prev.autoconf ];
      configurePhase = ''
        runHook preConfigure

        pushd modules

        tar -xf ${prev.zsh.src}
        ln -s $(pwd)/Src/fzftab.c zsh-${prev.zsh.version}/Src/Modules/
        ln -s $(pwd)/Src/fzftab.mdd zsh-${prev.zsh.version}/Src/Modules/

        pushd zsh-${prev.zsh.version}

        # Apply patches manually
        ${prev.lib.concatStringsSep "\n" (map (patch: "patch -p1 -i ${patch}") prev.zsh.patches)}

        if [[ ! -f ./configure ]]; then
          ./Util/preconfig
        fi
        if [[ ! -f ./Makefile ]]; then
          ./configure --disable-gdbm --without-tcsetpgrp
        fi

        popd
        popd

        runHook postConfigure
      '';
    });
  };
}
