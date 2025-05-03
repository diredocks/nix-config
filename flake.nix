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
      makeConfig = host: home:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = [
            # System configuration
            ./hosts/${host}/configuration.nix
            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.leo = import ./hosts/${host}/${home};
            }
            # agenix
            agenix.nixosModules.default
            ({pkgs, ...}: {
              environment.systemPackages = [agenix.packages.${pkgs.system}.default];
            })
          ];
        };
    in {
      probook-nix = makeConfig "probook-nix" "home.nix";
      pixelbook-nix = makeConfig "pixelbook-nix" "home.nix";
      claw-jp = makeConfig "claw-jp" "home.nix";
    };
  };
}
