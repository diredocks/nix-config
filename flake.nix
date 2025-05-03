{
  description = "Diredocks' NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";
    home-manager = {
      url = "github:nix-community/home-manager?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-gestures = {
      url = "github:taj-ny/kwin-gestures?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };
    disko = {
      url = "github:nix-community/disko?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alacritty-theme,
    agenix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
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
        home,
        withDisko ? false,
        withHomeManager ? true,
        withAge ? true,
      }:
        nixpkgs.lib.nixosSystem {
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
                home-manager.users.leo = import ./hosts/${host}/${home};
              }
            ]
            ++ mkModules withAge [
              inputs.agenix.nixosModules.default
              ({pkgs, ...}: {
                environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
              })
            ];
        };
    in {
      probook-nix = makeConfig {
        host = "probook-nix";
        home = "home.nix";
      };
      pixelbook-nix = makeConfig {
        host = "pixelbook-nix";
        home = "home.nix";
      };
      claw-jp = makeConfig {
        host = "claw-jp";
        home = "home.nix";
        withDisko = true;
      };
    };

    packages.x86_64-linux = {
      image = self.nixosConfigurations.claw-jp.config.system.build.diskoImages;
    };
  };
}
