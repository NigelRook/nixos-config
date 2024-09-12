{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.easyeffects ];

  systemd.user.services.easyeffects = {
    enable = true;
    description = "Easy Effects";
    wantedBy = [ "default.target" ];
    requires = [ "pipewire.service" ];
    after = [ "pipewire.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "always";
    };
  };
}
