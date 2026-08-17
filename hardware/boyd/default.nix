{ nixos-hardware, pkgs, ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # Testing 16Gb system usability
  boot.kernelParams = [
    "mem=16G"
  ];
  boot.zswap.enable = true;

  boot.plymouth.enable = true;

  services.fwupd.enable = true;

  boot.loader.systemd-boot = {
    consoleMode = "5";
    editor = false;
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # Framework utilities
  environment.systemPackages = with pkgs; [
    fw-ectool
    framework-tool
  ];

  # Kernel modules for additional hardware options
  hardware.framework.enableKmod = false;

  # Edit fan curve
  hardware.fw-fanctrl = {
    enable = true;
    config = {
      defaultStrategy = "high";
      strategies = {
        "high" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            { temp = 0; speed = 15; }
            { temp = 30; speed = 15; }
            { temp = 40; speed = 30; }
            { temp = 70; speed = 60; }
            { temp = 75; speed = 80; }
            { temp = 85; speed = 100; }
          ];
        };
        "deaf" = {
          fanSpeedUpdateFrequency = 2;
          movingAverageInterval = 5;
          speedCurve = [
            { temp =  0; speed = 20; }
            { temp =  40; speed = 30; }
            { temp =  50; speed = 50; }
            { temp =  60; speed = 100; }
          ];
        };
        "aeolus" = {
          fanSpeedUpdateFrequency = 2;
          movingAverageInterval = 5;
          speedCurve = [
            { temp = 0; speed = 20; }
            { temp = 40; speed = 50; }
            { temp = 65; speed = 100; }
          ];
        };
      };
    };
  };
}
