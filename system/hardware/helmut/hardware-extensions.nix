{
  imports = [
    ../common/btrfs-attrs.nix
    ../common/intel-gpu.nix
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 16*1024;
    }
  ];
}
