# NixOS Config

Configuration files for setting up NixOS

## Partitioning

[disko.nix] contains partitioning information. To apply it, run:

`sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko/<host>.nix`

## Installing

Generate default configuration.nix with

`sudo nixos-generate-config --root /mnt`

Copy contents of system to /etc/nixos

Install with

```
cd /mnt
sudo nixos-install --flake /mnt/etc/nixos#<host>
```

## After install

Copy the contents of home to `~/.config/home-manager` then run

`home-manager switch`
