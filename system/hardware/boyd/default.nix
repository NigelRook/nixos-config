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
    "zswap.enabled=1"
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

  boot.kernelPackages = pkgs.linuxPackages_6_10;

  hardware.bluetooth.package = pkgs.bluez.overrideAttrs (finalAttrs: previousAttrs: rec {
    version = "5.78";

    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz";
      sha256 = "sha256-gw/tGRXF03W43g9eb0X83qDcxf9f+z0x227Q8A1zxeM=";
    };

    patches = [];

    buildInputs = previousAttrs.buildInputs ++ [
      pkgs.python3Packages.pygments
    ];
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
