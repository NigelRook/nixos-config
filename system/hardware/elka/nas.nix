{ pkgs, ... }:
{
  sops.secrets."homelab/disk-key" = {
    owner = "nigel";
  };

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  systemd.services.unlock-data-disks = {
    description = "Unlock secondary data disks with sops secret";
    after = [ "sops-nix.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "unlock-and-mount" ''
      ${pkgs.cryptsetup}/bin/cryptsetup open --key-file /run/secrets/homelab/disk-key /dev/disk/by-partlabel/disk-hdd-1-ironwolf-18T-luks hdd-1-ironwolf-18T
      ${pkgs.systemd}/bin/systemctl start srv-hdd_1_ironwolf_18T.mount
      ${pkgs.cryptsetup}/bin/cryptsetup open --key-file /run/secrets/homelab/disk-key /dev/disk/by-partlabel/disk-hdd-4-wdred-4T-luks hdd-4-wdred-4T
      ${pkgs.systemd}/bin/systemctl start srv-hdd_4_wdred_4T.mount
    '';
    };
  };

  fileSystems."/srv/data" = {
    fsType = "mergerfs";
    device = "/srv/hdd_1_ironwolf_18T/data:/srv/hdd_4_wdred_4T/data";
    options = [
      "fsname=data"
      "category.create=msppfrd"
      "func.getattr=newest"
      "minfreespace=100G"
      "noauto"
      "nofail"
    ];
  };

  systemd.services.mount-data = {
    description = "Mount /src/data mergerfs filesystem";
    after = [ "unlock-data-disks.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.systemd}/bin/systemctl start srv-data.mount";
    };
  };
}
