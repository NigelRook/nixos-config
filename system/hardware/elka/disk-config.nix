{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
                  type = "btrfs";
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "noatime" "nodiratime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "noatime" "nodiratime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "noatime" "nodiratime" ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "noatime" "nodiratime" ];
                    };
                    "/snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [ "noatime" "nodiratime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
