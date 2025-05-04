let
  systems = {
    probook-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbtqmVJe9oQqMhFWSS2/R/lH6wHQK4byRLV6ibhn0Ej root@probook-nix";
    claw-jp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWvxCLB/fz+wthAxYJnmcVrRiXA9N89sJG2fPleJtFu root@claw-jp";
  };
  users = {
    leo_probook-nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2s5eFblq+fidM+RYbCTVIDWLAOvHloXkzg2EFGOnDT leo@probook-nix";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in {
  "xray_claw-jp.json".publicKeys = allUsers ++ [systems.probook-nix systems.claw-jp];
}
