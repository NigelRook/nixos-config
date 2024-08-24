{ nixos-hardware, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ../common/btrfs-attrs.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
    ./abm.nix
    ../../modules/hack-systemd-boot-opts
    ../../modules/fw-battery-sustainer
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

  boot.loader.systemd-boot = {
    consoleMode = "8";
    editor = false;
  };

  # Framework utilities
  environment.systemPackages = with pkgs; [
    fw-ectool
    framework-tool
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel modules for additional hardware options
  hardware.framework.enableKmod = false;

  # Disable Active Backlight Manager (ABM results in poor contrast on battery in power saver mode)
  hardware.framework.abm = false;
}
