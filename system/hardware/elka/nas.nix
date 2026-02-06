{ pkgs, ... }:
{
  sops.secrets."homelab/disk-key" = {
    owner = "nigel";
  };

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  environment.etc.crypttab.text = ''
    hdd-1-ironwolf-18T PARTLABEL=disk-hdd-1-ironwolf-18T-luks /run/secrets/homelab/disk-key nofail
    hdd-4-wdred-4T PARTLABEL=disk-hdd-4-wdred-4T-luks /run/secrets/homelab/disk-key nofail
  '';

  fileSystems."/srv/data" = {
    fsType = "mergerfs";
    device = "/srv/hdd_1_ironwolf_18T/data:/srv/hdd_4_wdred_4T/data";
    options = [
      "fsname=data"
      "category.create=msppfrd"
      "func.getattr=newest"
      "minfreespace=100G"
      "nofail"
    ];
  };
}
