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
    ./virt.nix
    ./shell.nix
    ./others.nix
  ];
}
