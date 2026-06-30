# NixOS Config

Configuration files for setting up NixOS

## Partitioning

Each system has a `disk-config.nix` under `hardware/<host>/` containing a disko configuration. For a new system, createTo apply this, run:

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hardware/<host>/disk-config.nix
```

## Installing

For live ISO installs, boot the live ISO and clone this repo.

For remote installs, changes can be made to this repo on the local machine

### disko config

If the machine doesn't have one, craft a suitable disko config at `hardware/MACHINE_NAME/disk-config.nix`

### Partitioning (live ISO only)

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hardware/MACHINE_NAME/disk-config.nix
```

### Base config

If you don't already have a configuration for the system, create `hardware/MACHINE_NAME/default.nix`

```nix
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

```bash
sudo nixos-generate-config --show-hardware-config --no-filesystems --root /mnt > hardware/<host>/hardware-configuration.nix
```

### Flake entry

If one doesn't already exist, add an entry to [flake.nix](flake.nix)

```nix
  outputs = { ... }:
  let
    hardware = {
      MACHINE_NAME = {
        system = ARCH;
        modules = [ MODULES ];
      };
```

### Temporary sops key (live ISO)

```bash
sudo mkdir -p /mnt/tmp/sops
sudo mount -t tmpfs -o size=1m sops /mnt/tmp/sops
```

Create `/mnt/tmp/sops/key.txt` containing the required key

### Temporary sops key (remote)

```bash
temp=$(mktemp -d)
mkdir -p $temp/tmp/sops/
```

Create `$temp/tmp/sops/key.txt` containing the required key, eg.

```bash
cp /run/secrets/users/nigel/admin-key $temp/tmp/sops/key.txt
```

### Store repo changes

For remote, this is just adding and committing your changes

For live ISO, you'll need to at least `git add` new files (required by flakes). You may want to copy the git repo over to `/mnt/home/nigel` and push from the new system rather than signing in to git from the live ISO.

### Install (live ISO)

```bash
sudo nixos-install --flake .#<host>
```

### Install (remote)

Boot the target machine with a nixos live iso. Set a root password using `sudo passwd`

On local machine, run `export SSHPASS=<target machine password>`

Then run

```bash
targethost=MACHINE_NAME
targetip=TARGET_IP
nix run github:nix-community/nixos-anywhere -- \
  --flake .#${targethost} \
  --generate-hardware-config nixos-generate-config hardware/${targethost}/hardware-configuration.nix \
  --extra-files ${temp} \
  --env-password \
  --target-host root@${targetip}
```

You might also need

```bash
  --disk-encryption-keys /run/secrets/homelab/disk-key /run/secrets/homelab/disk-key \
```

## After install

### Add sops key

Remove any lingering admin key

```bash
sudo rm -rf /tmp/sops
```

From the running system, get the age public key with

```bash
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```

Add this to [.sops.yaml](.sops.yaml), then update the secrets file with

```bash
sops updatekeys secrets/secrets.yaml
```

### Chezmoi

Init chezmoi with

```bash
chezmoi init https://github.com/NigelRook/dotfiles-chezmoi.git
```

After answering prompts, apply this with

```bash
chezmoi apply
```

Then add the provided ssh key to github

### Enabling secure boot

If you have [hardware/common/secure-boot.nix](hardware/common/secure-boot.nix) in your configuration, enabling setup mode from the bios (possibly just by deleting all keys) will enroll keys at next bootup and secure boot should be enabled. Check with

```bash
sbctl status
```

### Enabling tpm2 auto-unlock of LUKS partition

Provided secure boot is enabled, you can save the root disk decryption key to the TPM with

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs="7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000" /dev/<root-partition>
```
