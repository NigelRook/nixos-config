{ pkgs, config, ... }:
let
  smbPasswordScript = user: passwordPath: {
    text = ''
      ${pkgs.coreutils}/bin/printf "$(${pkgs.coreutils}/bin/cat ${passwordPath})\n$(${pkgs.coreutils}/bin/cat ${passwordPath})\n" | ${pkgs.samba}/bin/smbpasswd -sa "${user}"
    '';
  };
in
{
  services.samba = {
    enable = true;
    package = pkgs.samba4.override {
      enableMDNS = true;
    };
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = config.networking.hostName;
        "netbios name" = config.networking.hostName;
        "security" = "user";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.2. 10.42. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "media" = {
        "path" = "/export/media";
        "browseable" = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "write list" = "nigel ruth";
        "create mask" = "0664";
        "directory mask" = "0775";
        "force user" = "nigel";
        "force group" = "users";
      };
      "timemachine" = {
        "path" = "/export/timemachine";
        "valid users" = "@users";
        "public" = "no";
        "writeable" = "yes";
        "create mask" = "0664";
        "directory mask" = "0775";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
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
    extraServiceFiles = {
      timemachine = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
            <service>
            <type>_device-info._tcp</type>
            <port>0</port>
            <txt-record>model=TimeCapsule8,119</txt-record>
          </service>
          <service>
            <type>_adisk._tcp</type>
            <txt-record>dk0=adVN=timemachine,adVF=0x82</txt-record>
            <txt-record>sys=waMa=0,adVF=0x100</txt-record>
          </service>
        </service-group>
      '';
    };
  };

  sops.secrets."users/nigel/samba-password" = {};
  system.activationScripts.nigel_smbpasswd = smbPasswordScript "nigel" config.sops.secrets."users/nigel/samba-password".path;

  users.users.ruth = {
    isNormalUser = true;
    description = "Ruth";
    uid = 1001;
    shell = pkgs.shadow + "/bin/nologin";
    createHome = false;
  };
  sops.secrets."users/ruth/samba-password" = {};
  system.activationScripts.ruth_smbpasswd = smbPasswordScript "ruth" config.sops.secrets."users/ruth/samba-password".path;
}
