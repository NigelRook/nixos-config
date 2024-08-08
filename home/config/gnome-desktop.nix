{ pkgs, lib, ... }:
{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/Console" = {
        font-scale = lib.mkDefault 1.1;
        audible-bell = false;
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${../files/wallpaper.png}";
        picture-uri-dark = "file://${../files/wallpaper.png}";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${../files/wallpaper.png}";
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.hibernate-status-button.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
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

      "org/gnome/desktop/screensaver".lock-delay = lib.hm.gvariant.mkUint32 1800;
    };
  };
}
