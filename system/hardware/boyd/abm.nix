{ config, lib, pkgs, ... }:
{
  options = {
    hardware.framework.abm = lib.mkOption {
      description = "Whether to enable Active Backlight Manager when using power-profiles-daemon";
      type = lib.types.bool;
      default = true;
      example = false;
    };
  };

  config = lib.mkIf ((! config.hardware.framework.abm) && config.services.power-profiles-daemon.enable) {
    systemd.packages = [
      (pkgs.runCommandNoCC "power-profiles-daemon.service.d/10-disable-abm.conf" {
        preferLocalBuild = true;
        allowSubstitutes = false;
      } ''
        mkdir -p $out/etc/systemd/system/power-profiles-daemon.service.d/
        cat > $out/etc/systemd/system/power-profiles-daemon.service.d/10-disable-abm.conf <<EOF
        [Service]
        ExecStart=
        ExecStart=${pkgs.power-profiles-daemon}/libexec/power-profiles-daemon --block-action=amdgpu_panel_power
        EOF
      '')
    ];
  };
}
