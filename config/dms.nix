{ pkgs, inputs, ... }:
{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
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
}
