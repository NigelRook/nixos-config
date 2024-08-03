{
  imports = [ ../common/btrfs-attrs.nix ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  boot.resumeDevice = "/dev/mapper/nixos";
  boot.kernelParams = [
    # sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    "resume_offset=2456778"
  ];

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 16*1024;
    }
  ];
}
