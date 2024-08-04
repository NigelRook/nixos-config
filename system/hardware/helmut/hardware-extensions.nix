{
  imports = [
    ../common/btrfs-attrs.nix
    ../../modules/btrfs-hibernate
  ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  boot.resumeDevice = "/dev/mapper/nixos";
  btrfs-hibernate.swapFileOffset = 2456778;

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 16*1024;
    }
  ];
}
