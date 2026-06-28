{ lib, ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/bootstrap-sops.nix
    ./raspberrypi5.nix
  ];

  boot.loader.systemd-boot = {
    consoleMode = "2";
    editor = false;
  };

  # temp disable k3s
  services.k3s.enable = lib.mkForce false;
}
