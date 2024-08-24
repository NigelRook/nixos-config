{ pkgs, ... }:
{
  systemd.services.fw-battery-sustainer = {
    enable = true;
    after = [ "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.fw-ectool}/bin/ectool fwchargelimit 80";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
