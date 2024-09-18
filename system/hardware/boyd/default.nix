{ nixos-hardware, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ../common/btrfs-attrs.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.fw-fanctrl.nixosModules.default
    ../../modules/hack-systemd-boot-opts
    ../../modules/easyeffects
    #../../modules/fw-battery-sustainer
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 32*1024;
    }
  ];

  #services.xserver.videoDrivers = [ "amdgpu" ];

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

  # Edit fan curve
  programs.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "mine";
      strategies = {
        "mine" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            { temp = 0; speed = 0; }
            { temp = 35; speed = 0; }
            { temp = 40; speed = 20; }
            { temp = 50; speed = 40; }
            { temp = 80; speed = 80; }
            { temp = 90; speed = 100; }
          ];
        };
      };
    };
  };
}
