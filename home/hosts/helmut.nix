{
  imports = [ ../archetypes/personal-laptop.nix ];

  dconf.settings."org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" ];
}
