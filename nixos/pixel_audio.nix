{ inputs, outputs, lib, config, pkgs, ... }:
let
  cb-linux-audio = pkgs.fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "chromebook-linux-audio";
    rev = "575dfddc7dd215916eee2d16a058191875272687"; # to be filed by commit
    hash = "sha256-77s679xcXVbnkTUpHoRjIvB6Zhuxyaqf6Yzmgb0ZXVo="; # would emerge when error occurs
  };
  cb-ucm-conf = pkgs.fetchzip {
    url = "https://github.com/WeirdTreeThing/alsa-ucm-conf-cros/archive/refs/tags/0.4.zip";
    hash = "sha256-GHrK85DmiYF6FhEJlYJWy6aP9wtHFKkTohqt114TluI="; # would emerge when error occurs
  };
  #topology-package = pkgs.runCommandNoCC "topology-package" {} ''
  #  mkdir -p $out/lib/firmware/intel/avs
  #  cp -av ${cb-linux-audio}/conf/avs/tplg/* $out/lib/firmware/intel/avs
  #'';
  topology-package = pkgs.stdenvNoCC.mkDerivation {
    name = "topology-package";
    src = cb-linux-audio;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/firmware/intel/avs
      cp -avrf ${cb-linux-audio}/conf/avs/tplg/* $out/lib/firmware/intel/avs
      runHook postInstall
    '';
  };
  alsa-ucm-conf-cb = pkgs.alsa-ucm-conf.overrideAttrs (
    old: {
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/alsa/ucm2
        cp -rf ${cb-ucm-conf}/ucm2/* $out/share/alsa/ucm2

        runHook postInstall
      '';
    }
  );
  linux-cb-kernel = pkgs.linuxManualConfig {
    inherit (pkgs.linux_6_6) src modDirVersion;
    version = "${pkgs.linux_6_6.version}-cb";
    configfile = ./cb-custom.config;
    allowImportFromDerivation = true;
  };

in
{
  config = {
    hardware.firmware = [ topology-package ];
    system.replaceRuntimeDependencies = [
      {
        original = pkgs.alsa-ucm-conf;
        replacement = alsa-ucm-conf-cb;
      }
    ];
    boot.kernelPackages = pkgs.linuxPackagesFor linux-cb-kernel;
    #environment.systemPackages = [
    #  alsa-ucm-conf-cb
    #];
    environment.etc."wireplumber/main.lua.d/51-avs-dmic.lua".text =
      builtins.readFile (cb-linux-audio + "/conf/avs/51-avs-dmic.lua");
    environment.etc."wireplumber/main.lua.d/51-increase-headroom.lua".text =
      builtins.readFile (cb-linux-audio + "/conf/common/51-increase-headroom.lua");
  };
}
