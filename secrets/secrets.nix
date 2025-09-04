let
  sshKeys = import ./ssh-keys-pub.nix;
in {
  "vmiss-la-eth0.network".publicKeys =
    sshKeys.allUsers
    ++ [
      sshKeys.systems.probook-nix
      sshKeys.systems.vmiss-la
    ];
}
