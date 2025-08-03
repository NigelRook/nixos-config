{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.powertop ];
  powerManagement.powertop.enable = true;

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      IdleAction=suspend-then-hibernate
      IdleActionSec=10m
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=4h
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };
}
