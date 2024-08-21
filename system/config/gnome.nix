{ pkgs, lib, ... }:
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

  programs.dconf.profiles = {
    user = {
      enableUserDb = true;
      databases = [{
        settings = with lib.gvariant; {
          "org/gnome/mutter".dynamic-workspaces = true;

          "org/gnome/Console" = {
            audible-bell = false;
          };

          "org/gnome/desktop/interface" = {
            enable-hot-corners = false;
          };

          "org/gnome/desktop/wm/keybindings" = {
            toggle-fullscreen = [ "<Super>F11" ];
          };

          "org/gnome/desktop/background" = {
            picture-uri = "file://${../files/wallpaper.png}";
            picture-uri-dark = "file://${../files/wallpaper.png}";
          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = "file://${../files/wallpaper.png}";
            lock-delay = mkUint32 1800;
          };

          "org/gnome/shell" = {
            enabled-extensions = with pkgs.gnomeExtensions; [
              hibernate-status-button.extensionUuid
              appindicator.extensionUuid
              clipboard-history.extensionUuid
            ];
            favorite-apps = [
              "firefox.desktop"
              "steam.desktop"
              "code.desktop"
              "org.gnome.Console.desktop"
              "org.gnome.Nautilus.desktop"
            ];
          };

          "org/gnome/shell/extensions/hibernate-status-button" = {
            show-hybrid-sleep = false;
            show-suspend-then-hibernate = false;
          };
        };
      }];
    };
  };
}
