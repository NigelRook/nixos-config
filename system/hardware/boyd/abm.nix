{ config, lib, pkgs, ... }:
{
  options = {
    hardware.framework.abm = lib.mkEnableOption {
      description = "Whether to enable Active Backlight Manager when using power-profiles-daemon";
      default = true;
      example = false;
    };
  };

  config = lib.mkIf ((! config.hardware.framework.abm) && config.services.power-profiles-daemon.enable) {
    systemd.packages = [
      (pkgs.runCommandNoCC "power-profiles-daemon.d/disable-abm.conf" {
        preferLocalBuild = true;
        allowSubstitutes = false;
      } ''
        mkdir -p $out/etc/systemd/system/power-profiles.daemon.d/
        cat > $out/etc/systemd/system/power-profiles.daemon.d/disable-abm.conf <<EOF
        [Service]
        ExecStart=
        ExecStart=/usr/lib/power-profiles-daemon --block-action=amdgpu_panel_power
        EOF
      '')
    ];
  };
}
