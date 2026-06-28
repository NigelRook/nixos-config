{ lib, ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ./raspberrypi5.nix
    ./remote-luks-unlock.nix
  ];

  boot.loader.systemd-boot = {
    consoleMode = "2";
    editor = false;
  };

  # temp disable k3s
  services.k3s.enable = lib.mkForce false;
}
