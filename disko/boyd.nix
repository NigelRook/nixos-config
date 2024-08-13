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
                };
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "noatime" ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "noatime" ];
                    };
                    "/snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [ "noatime" ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      mountOptions = [ "noatime" ];
                      swap.swapfile.size = "32G";
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
