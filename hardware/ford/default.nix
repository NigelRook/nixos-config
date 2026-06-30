{ lib, ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/secure-boot.nix
  ];

  # temp disable k3s
  services.k3s.enable = lib.mkForce false;
}
