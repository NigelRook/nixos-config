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
    HibernateDelaySec=2h
  '';
}
