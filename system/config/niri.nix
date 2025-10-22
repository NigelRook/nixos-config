{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;

  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true; # secret service

  environment.systemPackages = with pkgs; [
    ptyxis
    fuzzel
    swaylock
    swayidle
    swaybg
    mako
    waybar
    blanket
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
