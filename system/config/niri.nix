{ lib, pkgs, inputs, ... }:
{
  services.displayManager.gdm.enable = true;

  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};
  services.gnome.gnome-keyring.enable = true; # secret service

  security.pam.services.login.fprintAuth = lib.mkForce true;
  # systemd.user.services.swaybg = {
  #   enable = true;

  #   partOf = "graphical-session.target";
  #   after = "graphical-session.target";
  #   requisite = [ "graphical-session.target" "niri.service" ];

  #   serviceConfig = {
  #     ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${../files/wallpaper.png}";
  #     Restart = "on-failure";
  #   };
  # };

  # systemd.user.services.swayidle = {
  #   enable = true;

  #   partOf = "graphical-session.target";
  #   after = "graphical-session.target";
  #   requisite = [ "graphical-session.target" "niri.service" ];

  #   serviceConfig = {
  #     ExecStart = "${pkgs.swaybg}/bin/swayidle -w timeout 601 'niri msg action power-off-monitors' timeout 600 'swaylock -f' before-sleep 'swaylock -f'";
  #     Restart = "on-failure";
  #   };
  # };

  fonts.packages = with pkgs; [
    inter
    fira-code
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    ptyxis
    swaylock
    blanket
    xwayland-satellite
    adwaita-icon-theme

    inputs.quickshell.packages.${system}.quickshell
    inputs.dankMaterialShell.packages.${system}.default
    material-symbols

    ddcutil
    libsForQt5.qt5ct
    kdePackages.qt6ct
    inputs.dms-cli.packages.${system}.dms-cli
    inputs.dgop.packages.${system}.dgop
    cliphist
    wl-clipboard
    brightnessctl
    hyprpicker
    matugen
    cava#
    kdePackages.qtmultimedia
    adw-gtk3
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
