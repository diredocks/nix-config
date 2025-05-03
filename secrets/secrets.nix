let
  systems = {
    probook-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMafAIGf0YhzTdkouJfZjRMBfOByPFAxUg6WkhEs9wU root@hp-nixos";
  };
  users = {
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  "xray.age".publicKeys = allUsers ++ [systems.probook-nix];
}
