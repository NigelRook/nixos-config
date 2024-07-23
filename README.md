# NixOS Config

Configuration files for setting up NixOS

## Partitioning

[disko.nix] contains partitioning information. To apply it, run:

`sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko/<host>.nix`

## Installing

Copy nix config to /etc/nixos

Generate hardware-configuration.nix with

`sudo nixos-generate-config --show-hardware-config --root /mnt > /mnt/etc/nixos/hardware-configuration.nix`

Install with

`sudo nixos-install --flake /mnt/etc/nixos#<host>`
