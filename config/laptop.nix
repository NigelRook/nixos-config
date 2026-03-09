{ pkgs, lib, ... }:
{
  nix.gc.dates = "Sat *-*-* 22:00:00";

  environment.systemPackages = [ pkgs.powertop ];
  powerManagement.powertop.enable = true;

  services.logind.settings.Login = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      IdleAction=suspend-then-hibernate
      IdleActionSec=10m
    '';
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "4h";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };

  networking.networkmanager.wifi = {
    backend = lib.mkDefault "iwd";
    powersave = lib.mkDefault true;
  };
}
