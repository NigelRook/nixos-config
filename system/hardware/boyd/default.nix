{ nixos-hardware, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ../common/btrfs-attrs.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 32*1024;
    }
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.fwupd.enable = true;

  boot.kernelParams = [ "zswap.enable=1" ];
}
