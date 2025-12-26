{
  inputs,
  lib,
  config,
  pkgs,
  ...
}
: let
  alsa-ucm-conf-cros = with pkgs;
    alsa-ucm-conf.overrideAttrs {
      wttsrc = fetchFromGitHub {
        owner = "WeirdTreeThing";
        repo = "alsa-ucm-conf-cros";
        rev = "a4e9213";
        hash = "sha256-3TpzjmWuOn8+eIdj0BUQk2TeAU7BzPBi3FxAmZ3zkN8=";
      };
      postInstall = ''
        cp -R $wttsrc/ucm2/codecs/* $out/share/alsa/ucm2/codecs
        cp -R $wttsrc/ucm2/platforms/* $out/share/alsa/ucm2/platforms
        cp -R $wttsrc/ucm2/conf.d/* $out/share/alsa/ucm2/conf.d
        cp -R $wttsrc/overrides/* $out/share/alsa/ucm2/conf.d
        rm $out/share/alsa/ucm2/conf.d/avs_dmic/Google-Atlas-1.0.conf
      '';
    };
in {
  environment.sessionVariables = {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-cros}/share/alsa/ucm2";
  };
  system.replaceDependencies.replacements = [
    ({
      oldDependency = pkgs.alsa-ucm-conf;
      newDependency = alsa-ucm-conf-cros;
    })
  ];
  services.pipewire.wireplumber.extraConfig = {
    "increase-headroom" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "~alsa_output.*";
            }
          ];
          actions = {
            update-props = {
              "api.alsa.headroom" = "4096";
            };
          };
        }
      ];
    };
  };
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=4
    options snd-soc-avs ignore_fw_version=1
    options snd-soc-avs obsolete_card_names=1
  '';
}
