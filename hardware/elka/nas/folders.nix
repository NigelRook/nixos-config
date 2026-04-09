{ pkgs, ... }:
let
  systemdManagedDir = path: requiredMount: owner: group: mode: {
    enable = true;
    description = "Ensure ${path} exists after mount";

    after = [ requiredMount ];
    requires = [ requiredMount ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [ pkgs.coreutils ];

    script = ''
      mkdir -p "${path}"
      chown ${owner}:${group} "${path}"
      chmod ${mode} "${path}"
    '';

    wantedBy = [ "multi-user.target" ];
  };
in
{
  system.activationScripts = {
    makeFolders = {
      text =
        ''
          mkdir -p /export
          mkdir -p /srv
        '';
    };
  };

  systemd.services = {
    hdd1-data = systemdManagedDir "/srv/hdd_1_ironwolf_18T/data" "srv-hdd_1_ironwolf_18T.mount" "root" "users" "0775";
    hdd2-data = systemdManagedDir "/srv/hdd_2_ironwolf_18T/data" "srv-hdd_2_ironwolf_18T.mount" "root" "users" "0775";
    hdd3-data = systemdManagedDir "/srv/hdd_3_exos_16T/data" "srv-hdd_3_exos_16T.mount" "root" "users" "0775";
    hdd4-data = systemdManagedDir "/srv/hdd_4_wdred_4T/data" "srv-hdd_4_wdred_4T.mount" "root" "users" "0775";

    hdd1-media = systemdManagedDir "/srv/hdd_1_ironwolf_18T/data/media" "srv-hdd_1_ironwolf_18T.mount" "nigel" "users" "0775";
    hdd2-media = systemdManagedDir "/srv/hdd_2_ironwolf_18T/data/media" "srv-hdd_2_ironwolf_18T.mount" "nigel" "users" "0775";
    hdd3-media = systemdManagedDir "/srv/hdd_3_exos_16T/data/media" "srv-hdd_3_exos_16T.mount" "nigel" "users" "0775";
    hdd4-media = systemdManagedDir "/srv/hdd_4_wdred_4T/data/media" "srv-hdd_4_wdred_4T.mount" "nigel" "users" "0775";

    timemachine-dir = systemdManagedDir "/srv/data/timemachine" "srv-data.mount" "root" "users" "0775";
    backups-dir = systemdManagedDir "/srv/data/backups" "srv-data.mount" "root" "users" "0775";
    objstore-dir = systemdManagedDir "/srv/data/objstore" "srv-data.mount" "root" "users" "0700";
  };
}
