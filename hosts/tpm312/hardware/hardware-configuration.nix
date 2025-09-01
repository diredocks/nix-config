{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = ["earlycon" "console=ttyS2,1500000" "consoleblank=0"];

  # TODO: device tree from https://github.com/unifreq/linux-6.6.y/blob/main/arch/arm64/boot/dts/rockchip/rk3399-tpm312.dts
}
