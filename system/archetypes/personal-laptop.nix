{ lib, ... }:
{
  imports = [
    ../config/secure-boot.nix
    ../config/gnome-desktop.nix
    ../config/gaming.nix
  ];

  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false;
}
