let
  systems = {
    probook-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbtqmVJe9oQqMhFWSS2/R/lH6wHQK4byRLV6ibhn0Ej root@probook-nix";
    vmiss-la = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9stKvE4KD2jYb2mBYKt9gVmNi76tKjn9YWpjpkDvk/";
  };

  users = {
    leo_probook-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXn0O9OwDImP05mnIzbSmGdNdcg7HJ3wpdBRIi+TEwA leo@probook-nix";
  };
in {
  inherit users systems;
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
}
