{
  inputs,
  lib,
  config,
  pkgs,
  ...
}
: {
  boot.loader.systemd-boot.enable = true;
  boot.initrd.systemd.enable = true;
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;
}
