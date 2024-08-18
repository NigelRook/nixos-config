# NixOS Config

Configuration files for setting up NixOS

## Partitioning

[disko/](disko/) contains partitioning information. To apply it, run:

```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko/<host>.nix
```

## Installing

### Creating config for a new host

Generate default configuration.nix with

```
sudo nixos-generate-config --root /mnt
```

Copy hardware-configuration.nix to `system/hardware/<host>`

Create `system/hardware/<host>/default.nix` with

```
{
  imports = [ ./hardware-configuration.nix ];
}
```

And add any other host-specific configuration and imports to this file

`git add` newly created files. Optionally commit them

Finally, add an entry to [system/flake.nix](system/flake.nix)

```
  outputs = {  ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = ...
    in
    builtins.mapAttrs systemDef {
      ...
      host = [ modules ]
    };
  };
```

If you don't want to commit changes yet (you probably don't have suitable credentials), copy them somewhere under `/mnt`

### Installing NixOS

```
sudo nixos-install --flake ./system#<host>
```

Commit and merge changes

## After install

### Configuring home-manager

Optionally, create `home/hosts/host.nix` containing host-specific configuration for all users

Add entries to [home/flake.nix](home/flake.nix)

```
  outputs = { ... }:
    {
      homeConfigurations =
      let
        configDef =  ...
      in
      builtins.mapAttrs configDef {
        ...
        "user1@host" = [ <modules> ]
        "user2@host" = [ <modules> ]
      };
    };
```

### Applying home-manager

```
home-manager switch --flake ./home
```

### Enabling secure boot

Generate signing keys with

```
nix run nixpgks#sbctl create-keys
```

Enable setup mode from bios (possibly just by deleting all keys), then enroll the new keys with

```
nix run nixpgks#sbctl enroll-keys --microsoft
```

Then you can add the [system/hardware/common/secure-boot.nix](system/hardware/common/secure-boot.nix) module to your system configuration to enable secure boot

### Enabling tpm2 auto-unlock of LUKS partition

```
systemd-cryptenroll /dev/nvme0n1p2 --wipe-slot=tpm2 --tpm2-device=auto
```
