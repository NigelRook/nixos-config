{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "nigel";
      };
    };
  };

  security.pam.services.greetd.fprintAuth = false;

  systemd = {
    # To prevent getting stuck at shutdown
    settings = {
      Manager = {
        DefaultTimeoutStopSec = "10s";
      };
    };
    services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
