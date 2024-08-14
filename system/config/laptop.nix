{ pkgs, ... }:
{
  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;

  environment.systemPackages = [ pkgs.powertop ];
  powerManagement.powertop.enable = true;

  services.logind.lidSwitch = "suspend-then-hibernate";

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';
}
