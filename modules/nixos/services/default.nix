{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./git.nix
    ./sshd.nix
    ./shell.nix
    ./others.nix
  ];
}
