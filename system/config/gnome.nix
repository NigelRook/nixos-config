{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.hibernate-status-button
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-history
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    simple-scan
    gnome.gnome-weather
    gnome-calendar
    gnome.gnome-contacts
    gnome.gnome-maps
    yelp
  ];
}
