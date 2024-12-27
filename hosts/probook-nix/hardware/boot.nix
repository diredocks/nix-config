{
  inputs,
  lib,
  config,
  pkgs,
  ...
}
: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.extraEntries."arch.conf" = ''
    title Archlinux
    linux /vmlinuz-linux-lts
    initrd /initramfs-linux-lts.img
    options root=UUID=f6215e55-ec45-48d7-b403-df87b39efcfe rw
  '';
  boot.initrd.systemd.enable = true;
}
