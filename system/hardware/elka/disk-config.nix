{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SPCC_M.2_PCIe_SSD_AA250218N4102409641";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "nixos";
                settings = {
                  allowDiscards = true;
                  crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure-pcr=yes" ];
                };
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [ "noatime" "nodiratime" ];
                };
              };
            };
          };
        };
      };
      hdd-1-ironwolf-18T = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST18000NT001-3NF101_ZVTE0RXP";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "hdd-1-ironwolf-18T";
                passwordFile = "/run/secrets/homelab/disk-key";
                initrdUnlock = false;
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/srv/hdd_1_ironwolf_18T";
                  mountOptions = [ "noatime" "nodiratime" "nofail" ];
                };
              };
            };
          };
        };
      };
      hdd-2-ironwolf-18T = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST18000NE000-3G6101_ZVTEFDQR";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "hdd-2-ironwolf-18T";
                passwordFile = "/run/secrets/homelab/disk-key";
                initrdUnlock = false;
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/srv/hdd_2_ironwolf_18T";
                  mountOptions = [ "noatime" "nodiratime" "nofail" ];
                };
              };
            };
          };
        };
      };
      hdd-3-exos-16T = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST16000NM001G-2KK103_ZL2NPE69";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "hdd-3-exos-16T";
                passwordFile = "/run/secrets/homelab/disk-key";
                initrdUnlock = false;
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/srv/hdd_3_exos_16T";
                  mountOptions = [ "noatime" "nodiratime" "nofail" ];
                };
              };
            };
          };
        };
      };
      hdd-4-wdred-4T = {
        type = "disk";
        device = "/dev/disk/by-id/ata-WDC_WD40EFRX-68WT0N0_WD-WCC4E5CLE540";
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "hdd-4-wdred-4T";
                passwordFile = "/run/secrets/homelab/disk-key";
                initrdUnlock = false;
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/srv/hdd_4_wdred_4T";
                  mountOptions = [ "noatime" "nodiratime" "nofail" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
