{ lib, pkgs, modulesPath, ... }:

{
  fileSystems."/".options = [ "noatime" "nodiratime" ];

  boot.initrd.luks.devices."nixos".allowDiscards = true;

  boot.resumeDevice = "/dev/mapper/nixos";
  boot.kernelParams = [
    # sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    "resume_offset=2456778"
  ];

  fileSystems."/.snapshots".options = [ "noatime" "nodiratime" ];

  fileSystems."/.swapvol".options = [ "noatime" "nodiratime" ];

  fileSystems."/home".options = [ "noatime" "nodiratime" ];

  fileSystems."/nix".options = [ "noatime" "nodiratime" ];

  fileSystems."/var/log".options = [ "noatime" "nodiratime" ];

  swapDevices = [
    { device = "/.swapvol/swapfile";
      size = 16*1024;
    }
  ];
}
