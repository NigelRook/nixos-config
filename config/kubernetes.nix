{ pkgs, config, ... }:
{
  services.k3s = {
    enable = true;
    extraKubeletConfig = {
      shutdownGracePeriodByPodPriority = [
        {
          priority = 2000000000;
          shutdownGracePeriodSeconds = 15;
        }
        {
          priority = 1000000000;
          shutdownGracePeriodSeconds = 30;
        }
        {
          priority = 10000000;
          shutdownGracePeriodSeconds = 15;
        }
        {
          priority = 0;
          shutdownGracePeriodSeconds = 30;
        }
      ];
    };
  };

  systemd.services.k3s = {
    after = [ "iscsid.service" ];
    requires = [ "iscsid.service" ];
    serviceConfig = {
      TimeoutStopSec = 180;
    };
  };

  # Allow kubelet to delay shutdown for longer
  services.logind.settings.Login.InhibitDelayMaxSec = 180;

  services.openiscsi = {
    enable = true;
    name = "iqn.2016-04.com.open-iscsi:${config.networking.hostName}";
  };

  system.activationScripts.longhorn-fix = ''
    mkdir -p /usr/bin
    ln -sf /run/current-system/sw/bin/iscsiadm /usr/bin/iscsiadm
    ln -sf /run/current-system/sw/bin/mount /usr/bin/mount
    ln -sf /run/current-system/sw/bin/blkid /usr/bin/blkid
  '';

  boot.kernelModules = [ "iscsi_tcp" ];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];

  environment.systemPackages = with pkgs; [
    util-linux
    nfs-utils
    kubectl
    kubectx
  ];
}
