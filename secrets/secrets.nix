let
  sshKeys = import ./ssh-keys-pub.nix;
in {
  "xray_claw-jp.json".publicKeys =
    sshKeys.allUsers
    ++ [
      sshKeys.systems.probook-nix
      sshKeys.systems.claw-jp
    ];
}
