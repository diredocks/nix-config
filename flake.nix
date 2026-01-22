{
  description = "Diredocks' NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # alacritty-theme = {
    #   url = "github:alexghr/alacritty-theme.nix?shallow=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    inputactions = {
      url = "git+https://github.com/taj-ny/InputActions?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # wrangler = {
    #   url = "github:emrldnix/wrangler?shallow=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    # alacritty-theme,
    agenix,
    # wrangler,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages =
      forAllSystems (
        system:
          import ./pkgs nixpkgs.legacyPackages.${system}
      )
      // {
        # NOTE: build these images with `nix build .\#packages.xxx`
        tpm312-image = self.nixosConfigurations.tpm312.config.system.build.sdImage;
        vmiss-la-image = self.nixosConfigurations.vmiss-la.config.system.build.diskoImages;
        racknerd-image = self.nixosConfigurations.racknerd.config.system.build.diskoImages;
        aliyun-image = self.nixosConfigurations.aliyun.config.system.build.diskoImages;
      };
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = let
      mkModules = enabled: mods:
        if enabled
        then mods
        else [];
      makeConfig = {
        host,
        system ? "x86_64-linux",
        withDisko ? false,
        withHomeManager ? true,
        withAge ? true,
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules =
            [
              ./hosts/${host}/configuration.nix
            ]
            ++ mkModules withDisko [inputs.disko.nixosModules.disko]
            ++ mkModules withHomeManager [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit inputs;};
                home-manager.users.leo = import ./hosts/${host}/home.nix;
              }
            ]
            ++ mkModules withAge [
              inputs.agenix.nixosModules.default
              ({pkgs, ...}: {
                environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];
              })
            ];
        };
    in {
      probook-nix = makeConfig {
        host = "probook-nix";
      };
      pixelbook-nix = makeConfig {
        host = "pixelbook-nix";
      };
      vmiss-la = makeConfig {
        host = "vmiss-la";
        withDisko = true;
      };
      racknerd = makeConfig {
        host = "racknerd";
        withDisko = true;
      };
      aliyun = makeConfig {
        host = "aliyun";
        withDisko = true;
      };
      tpm312 = makeConfig {
        host = "tpm312";
        system = "aarch64-linux";
      };
    };
  };
}
