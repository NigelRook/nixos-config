{ nixos-hardware, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ../common/btrfs-attrs.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.fw-fanctrl.nixosModules.default
    ../../modules/hack-systemd-boot-opts
    #../../modules/fw-battery-sustainer
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 32*1024;
    }
  ];

  boot.resumeDevice = "/dev/mapper/nixos";
  boot.kernelParams = [
    # sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    "resume_offset=533760"
  ];

  #services.xserver.videoDrivers = [ "amdgpu" ];

  services.fwupd.enable = true;

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

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_10.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "0n385x7hc5pqxiiy26ampgzf56wqfvydg70va27xrhm7w1q9nj54";
      };
      version = "6.10.9";
      modDirVersion = "6.10.9";
    };
  });

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
