{ pkgs, ... }:
{
  services.displayManager.gdm.enable = true;

  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true; # secret service

  programs.waybar.enable = true; # top bar
  environment.systemPackages = with pkgs; [
    ptyxis
    fuzzel
    swaylock
    swayidle
    swaybg
    mako
    blanket
  ];
}
