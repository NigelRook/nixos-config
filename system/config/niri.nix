{ lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.dankMaterialShell.nixosModules.greeter
  ];

  nixpkgs.overlays = [
    inputs.quickshell.overlays.default
    (final: prev: {
      dms-cli = inputs.dms-cli.packages.${prev.system}.default;
      dgop = inputs.dgop.packages.${prev.system}.default;
      dankMaterialShell = inputs.dankMaterialShell.packages.${prev.system}.default;
    })
  ];

  programs.dankMaterialShell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/nigel"; # optionally copyies that users DMS settings (and wallpaper if set) to the greeters data directory as root before greeter starts
  };

  services.upower.enable = true;

  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true; # secret service

  security.pam.services.login.fprintAuth = true;

  # systemd.user.services.hyperpolkitagent.enable = true;

  systemd.user.services.dms = {
    enable = true;

    partOf = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    requisite = ["niri.service"];

    serviceConfig = {
      ExecStart = "${pkgs.dms-cli}/bin/dms run";
      Restart = "on-failure";
    };

    environment = {
      PATH = lib.mkForce null;
    };
  };

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
    enable = true;

    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.wluma}/bin/wluma";
      Restart = "on-failure";
    };
  };

  fonts.packages = with pkgs; [
    inter
    fira-code
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    quickshell
    dms-cli
    dgop
    dankMaterialShell

    xwayland-satellite
    brightnessctl
    ddcutil
    cliphist
    wl-clipboard
    mate.mate-polkit
    wluma
    hyprpicker
    cava#
    kdePackages.qtmultimedia
    adw-gtk3
    adwaita-icon-theme
    material-symbols
    libsForQt5.qt5ct
    kdePackages.qt6ct
    matugen

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
    DMS_DISABLE_MATUGEN = "1";
  };
}
