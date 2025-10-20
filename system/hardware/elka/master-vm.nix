{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu
    vagrant
  ];

  users.groups.libvirtd.members = ["nigel"];

  virtualisation.libvirtd.enable = true;
}
