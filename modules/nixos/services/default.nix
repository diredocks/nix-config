{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./others.nix
    ./shell.nix
    ./sshd.nix
    ./virt.nix
  ];
}
