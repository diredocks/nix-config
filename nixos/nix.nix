{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;

    trusted-users = [ "leo" ];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    extra-substituters = [
      "https://attic.alexghr.me/public"
    ];
    extra-trusted-public-keys = [
      "public:5MqPjBBGMCWbo8L8voeQl7HXc5oX+MXZ6BSURfMosIo="
    ];
  };

  systemd.services.nix-daemon.environment = {
    https_proxy = "http://127.0.0.1:9232";
  };

}
