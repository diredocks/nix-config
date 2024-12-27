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
        rev = "00b399e";
        hash = "sha256-lRrgZDb3nnZ6/UcIsfjqAAbbSMOkP3lBGoGzZci+c1k=";
      };
      postInstall = ''
        cp -R $wttsrc/ucm2/codecs/* $out/share/alsa/ucm2/codecs
        cp -R $wttsrc/ucm2/platforms/* $out/share/alsa/ucm2/platforms
        cp -R $wttsrc/ucm2/conf.d/* $out/share/alsa/ucm2/conf.d
      '';
    };
  chromebook-linux-audio = pkgs.fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "chromebook-linux-audio";
    rev = "e171791";
    hash = "sha256-5BZwVHsFHfNn1kMJzISJmUANRdFMVxEkfmb810X+h80=";
  };
in {
  environment = {
    systemPackages = with pkgs; [
      sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-cros}/share/alsa/ucm2";
  };
  hardware.firmware = [
    (
      pkgs.runCommand "avs-topology" {} ''
        mkdir -p /tmp/avs_tplg
        tar xf ${chromebook-linux-audio}/blobs/avs-topology_2024.02.tar.gz -C /tmp/avs_tplg
        mkdir -p $out/lib/firmware/intel/avs
        cp -R /tmp/avs_tplg/avs-topology/lib/firmware/intel/avs/* $out/lib/firmware/intel/avs
      ''
    )
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
    "avs-dmic" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.nick" = "Internal Microphone";
            }
          ];
          actions = {
            update-props = {
              "audio.format" = "S16LE";
            };
          };
        }
      ];
    };
  };
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=4
    options snd-soc-avs ignore_fw_version=1
  '';
}
