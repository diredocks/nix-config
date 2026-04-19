{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      auto-optimise-store = true;
      trusted-users = ["leo"];
      substituters = lib.mkDefault [
        "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store?priority=1"
      ];
      extra-substituters = [
        "https://cache.numtide.com?priority=10"
        "https://inputactions.cachix.org?priority=10"
      ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "inputactions.cachix.org-1:yBGhAqTOv0V08lrOTBwMAkU7V/9a0i2UPvsvCu39CjE="
      ];
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };
}
