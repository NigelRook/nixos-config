# NixOS Config

Configuration files for setting up NixOS

## Partitioning

Each system has a `disk-config.nix` under `system/hardware/<host>/` containing a disko configuration. For a new system, createTo apply this, run:

```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko system/hardware/<host>/disk-config.nix
```

## Installing

For live ISO installs, boot the live ISO and clone this repo.

For remote installs, changes can be made to this repo on the local machine

### disko config

If the machine doesn't have one, craft a suitable disko config at `system/hardware/MACHINE_NAME/disk-config.nix`

### Partitioning (live ISO only)

```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko system/hardware/MACHINE_NAME/disk-config.nix
```

### Base config

If you don't already have a configuration for the system, create `system/hardware/MACHINE_NAME/default.nix`

```
{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/bootstrap-sops.nix
  ];
}
```

Add any additional machine-specific config in here

### hardware-configuration.nix (live ISO only)

```
sudo nixos-generate-config --show-hardware-config --no-filesystems --root /mnt > system/hardware/<host>/hardware-configuration.nix
```

### Flake entry

If one doesn't already exist, add an entry to [flake.nix](system/flake.nix)

```
  outputs = {  ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = ...
    in
    builtins.mapAttrs systemDef {
      ...
      MACHINE_NAME = [ MODULES ]
    };
  };
```

### deplyy-rs profile (remote only)

If one doesn't already exist, add an entry to [flake.nix](system/flake.nix)

```
  deploy = ...
    ...
      nodes.MACHINE_NAME = {
        hostname = "MACHINE_NAME";
        profiles.system = {
          sshUser = "nigel";
          user = "root";
          interactiveSudo = true;
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.MACHINE_NAME;
        };
      };
```

### Temporary sops key (live ISO)

```
sudo mkdir -p /mnt/tmp/sops
sudo mount -t tmpfs -o size=1m sops /mnt/tmp/sops
```

Create `/mnt/tmp/sops/key.txt` containing the required key

### Temporary sops key (remote)

```
temp=$(mktemp -d)
mkdir -p $temp/tmp/sops/
```

Create `$temp/tmp/sops/key.txt` containing the required key

### Store repo changes

For remote, this is just adding and committing your changes

For live ISO, you'll need to at least `git add` new files (required by flakes). You may want to copy the git repo over to `/mnt/home/nigel` and push from the new system rather than signing in to git from the live ISO.

### Install (live ISO)

```
sudo nixos-install --flake ./system#<host>
```

### Install (remote)

Boot the target machine with a nixos live iso. Set a root password using `sudo passwd`

On local machine, run `export SSHPASS=<target machine password>`

Then run

```bash
targethost=MACHINE_NAME
targetip=TARGET_IP
nix run github:nix-community/nixos-anywhere -- \
  --flake ./system#${targethost} \
  --generate-hardware-config nixos-generate-config ./system/hardware${targethost}/hardware-configuration.nix \
  --extra-files=${temp} \
  --env-password \
  --target-host root@${targetip}$
```

## After install

### Add sops key

From the running system, get the age public key with

```
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```

Add this to [.sops.yaml](system/.sops.yaml), then update the secrets file with

```
sops updatekeys system/secrets/secrets.yaml
```

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
systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs="7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000" /dev/<root-partition>
```

## nixos-anywhere remote install

Boot the target machine with a nixos live iso. Set a root password using `sudo passwd`

On source machine, run `export SSHPASS=<target machine password>`

Then run

```bash
targethost=<target-host>
nix run github:nix-community/nixos-anywhere -- \
  --flake ./system#$targethost$ \
  --generate-hardware-config nixos-generate-config ./system/hardware/$targethost$/hardware-configuration.nix \
  --target-host root@<target-ip> --env-password
```
