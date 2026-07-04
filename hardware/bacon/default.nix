{ ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ./raspberrypi5.nix
    ./remote-luks-unlock.nix
  ];

  boot.loader.systemd-boot = {
    consoleMode = "2";
    editor = false;
  };

  services.k3s = {
    nodeTaint = [
      "disable-workloads=true:NoSchedule"
    ];
    serverAddr = "https://elka:6443";
  };

  systemd.services.k3s.environment = {
    GOMEMLIMIT = "768MiB";
  };

  # pi kernel disables memory cgroups by default, enable them
  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
  ];

  # Need swap to remote build packages
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8*1024;
  }];

  # Don't concurrent build packages with 2Gb ram
  nix.settings.max-jobs = 1;
}
