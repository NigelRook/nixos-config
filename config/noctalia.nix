{ pkgs, lib, ... }:
{
  imports = [
    ./greetd.nix
  ];

  services.power-profiles-daemon.enable = true;
  services.gnome.evolution-data-server.enable = true;

  systemd.user.services.noctalia-shell = {
    description = "Noctalia Shell - Wayland desktop shell";
    documentation = [ "https://docs.noctalia.dev" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    restartTriggers = [ pkgs.noctalia-shell ];

    environment = {
      PATH = lib.mkForce null;
    };

    serviceConfig = {
      ExecStart = lib.getExe pkgs.noctalia-shell;
      Restart = "on-failure";
    };
  };

  systemd.user.services.ciphist = {
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = lib.getExe pkgs.cliphist;
      Restart = "on-failure";
    };
  };

  services.upower.enable = true;
  services.gvfs.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    noctalia-qs
    noctalia-shell
    xwayland-satellite
    adw-gtk3
    adwaita-icon-theme
    nautilus
    ptyxis
    blanket
  ];
}
