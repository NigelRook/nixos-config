{ pkgs, config, ... }:
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

  fileSystems."/export/media" = {
    device = "/srv/data/media";
    options = [ "bind" "nofail" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export       192.168.2.0/24(fsid=0,crossmnt)
      /export/media 192.168.2.0/24(fsid=1,rw,sync,no_wdelay,insecure,anonuid=1000,anongid=1000,all_squash)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];

  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = config.networking.hostName;
        "netbios name" = config.networking.hostName;
        "security" = "user";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.2. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "media" = {
        "path" = "/export/media";
        "browseable" = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "write list" = "nigel";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "nigel";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    nssmdns4 = true;
    # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
    enable = true;
    openFirewall = true;
  };

  sops.secrets."users/nigel/samba-password" = {};

  system.activationScripts = {
    nigel_smbpasswd.text = ''
      /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets."users/nigel/samba-password".path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets."users/nigel/samba-password".path})\n" | /run/current-system/sw/bin/smbpasswd -sa nigel
    '';
  };
}
