{
  imports = [
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ../common/btrfs-attrs.nix
    ../common/intel-gpu.nix
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 16*1024;
    }
  ];

  # Boosting CPU causes brownouts due to broken battery
  # These settings prevent that
  services.tlp.settings = {
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
    CPU_BOOST_ON_AC = 0;
  };
}
