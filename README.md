# NixOS Config

Configuration files for setting up NixOS

## Partitioning

[disko.nix] contains partitioning information. To apply it, run:

`sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix`
