{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Required for GTK theming
  programs.dconf.enable = true;
}
