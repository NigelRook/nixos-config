{ pkgs, inputs, ... }:
{
  programs.niri.enable = true;

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/nigel"; # optionally copyies that users DMS settings (and wallpaper if set) to the greeters data directory as root before greeter starts
  };

  security.pam.services.greetd.fprintAuth = false;

  services.upower.enable = true;
  services.gvfs.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true; # secret service

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
    mate-polkit
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
