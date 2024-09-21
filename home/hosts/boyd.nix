{
  imports = [ ../archetypes/personal-laptop.nix ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter".experimental-features = [ "variable-refresh-rate" ];

      "org/gnome/desktop/background" = {
        picture-uri = "file://${../files/framework.jpeg}";
        picture-uri-dark = "file://${../files/framework.jpeg}";
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${../files/framework.jpeg}";
      };
    };
  };

  # Fix for camera power drain
  home.file.".config/wireplumber/wireplumber.conf.d/10-disable-camera.conf" = {
    enable = true;
    text = ''
      wireplumber.profiles = {
        main = {
          monitor.libcamera = disabled
        }
      }
    '';
  };

  services.easyeffects.enable = true;
}
