{ lib, ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/secure-boot.nix
  ];

  services.k3s = {
    serverAddr = "https://elka:6443";
  };
}
