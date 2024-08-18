{ nixos-hardware, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ../common/btrfs-attrs.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
    ./abm.nix
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

  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  boot.loader.systemd-boot.consoleMode = "2";

  # Framework utilities
  environment.systemPackages = with pkgs; [
    fw-ectool
    framework-tool
  ];

  # Kernel modules for additional hardware options
  #hardware.framework.enableKmod = true;

  # Disable Active Backlight Manager (ABM results in poor contrast on battery in power saver mode)
  hardware.framework.abm = false;
}
