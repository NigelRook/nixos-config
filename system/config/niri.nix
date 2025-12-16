{ pkgs, inputs, ... }:
{
  imports = [
    inputs.dankMaterialShell.nixosModules.dankMaterialShell
    inputs.dankMaterialShell.nixosModules.greeter
  ];

  programs.dankMaterialShell = {
    enable = true;
    systemd.enable = true;
  };

  programs.dankMaterialShell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/nigel"; # optionally copyies that users DMS settings (and wallpaper if set) to the greeters data directory as root before greeter starts
  };

  services.upower.enable = true;
  services.gvfs.enable = true;

  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true; # secret service

  systemd.user.services.wl-paste = {
    enable = true;

    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
  };

  systemd.user.services.wluma = {
    enable = false;

    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.wluma}/bin/wluma";
      Restart = "on-failure";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    mate.mate-polkit
    wluma
    adw-gtk3
    adwaita-icon-theme
    dconf-editor
    nautilus
    ptyxis
    blanket
  ];

  # wluma udev
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness"
    ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
  '';

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
