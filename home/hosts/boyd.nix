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
}
