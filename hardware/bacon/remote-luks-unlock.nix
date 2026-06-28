{ config, ... }:
{
  boot.initrd = {
    availableKernelModules = [ "rp1_pci" ];
    network = {
      enable = true;
      #udhcpc.enable = true;
      flushBeforeStage2 = true;
      ssh = {
        enable = true;
        port = 2222;
        authorizedKeys = [
          # boyd
          ''command="systemctl default" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJn2MzlgP2GCi2oMb3nYc/onyI4lSQxNgUPO3gP8PXp6''
        ];
        hostKeys = [ ./.ssh-unlock-hostkey ];
      };
    };
  };

  boot.kernelParams = [ "ip=::::${config.networking.hostName}::dhcp" ];
}
