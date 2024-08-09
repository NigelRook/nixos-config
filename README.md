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

## Enabling secure boot

Generate signing keys with `sbctl create-keys`

With setup mode enabled from bios (possibly just by deleting all keys) run `sbctl enroll-keys -m`

## Enabling tpm2 auto-unlock of LUKS partition

`systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=tpm2 --tpm2-device=auto`

## Enabling hibernate to swap file

```
  boot.resumeDevice = "/dev/mapper/nixos";
  boot.kernelParams = [
    # sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    "resume_offset=2456778"
  ];
```
