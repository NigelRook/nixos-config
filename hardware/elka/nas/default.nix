{ pkgs, ... }:
{
  imports = [
    ./filesystems.nix
    ./nfs.nix
    ./samba.nix
    ./folders.nix
  ];

  services.k3s.nodeLabel = [
    "nas=true"
  ];

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 244 /dev/%k"
  '';
}
