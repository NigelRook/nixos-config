{
  imports = [
    ./hardware-configuration.nix
    ../common/btrfs-attrs.nix
    ../common/amd-gpu.nix
    ../common/fingerprint.nix
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 32*1024;
    }
  ];
}
