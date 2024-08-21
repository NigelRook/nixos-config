{
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gfinal: gprev: {
        gnome-settings-daemon = gprev.gnome-settings-daemon.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or []) ++ [ ./gsd-power-manager.c.patch ];
        });
      });
    })
  ];
}
