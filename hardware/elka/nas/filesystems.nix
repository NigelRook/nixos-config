{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  sops.secrets."homelab/disk-key" = {
    owner = "nigel";
  };

  environment.etc.crypttab.text = ''
    hdd-1-ironwolf-18T PARTLABEL=disk-hdd-1-ironwolf-18T-luks /run/secrets/homelab/disk-key nofail
    hdd-2-ironwolf-18T PARTLABEL=disk-hdd-2-ironwolf-18T-luks /run/secrets/homelab/disk-key nofail
    hdd-3-exos-16T PARTLABEL=disk-hdd-3-exos-16T-luks /run/secrets/homelab/disk-key nofail
    hdd-4-wdred-4T PARTLABEL=disk-hdd-4-wdred-4T-luks /run/secrets/homelab/disk-key nofail
  '';

  fileSystems."/srv/data" = {
    fsType = "mergerfs";
    device = "/srv/hdd_1_ironwolf_18T/data:/srv/hdd_2_ironwolf_18T/data:/srv/hdd_4_wdred_4T/data:/srv/hdd_3_exos_16T/data";
    options = [
      "fsname=data"
      "category.create=msppfrd"
      "func.getattr=newest"
      "minfreespace=100G"
      "nofail"
    ];
  };

  fileSystems."/export/media" = {
    device = "/srv/data/media";
    options = [ "bind" "nofail" ];
  };

  fileSystems."/export/timemachine" = {
    device = "/srv/data/timemachine";
    options = [ "bind" "nofail" ];
  };
}
