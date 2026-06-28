# Remote unlock

Because the Raspberry Pi doesn't support securely using a TPM in order to unlock the encrypted root partition, [renote-luks-unlock.nix](./remote-luks-unlock.nix) allows unlocking via ssh instead.

To unlock:

```
ssh root@bacon -p 2222
```

Then enter password at the prompt.

## .ssh-unlock-hostkey

ssh in the initrd requires a consistent host key. This should be different to the primary host key since it's stored unencrypted on the disk. .ssh-unlock-hostkey is this key. It's encrypted with git-agecrypt

### Repo setup

To configure git-agecrypt hooks for the repo:

```
git-agecrypt init
```

To add a decryption key:

```
git-agecrypt config add -i age_private_key
```

### Encrypting a file

To configure a file for encryption:

```
git-agecrypt config add -r age_public_key -p file_to_encrypt
```

Then add to .gitattributes:

```
file_to_encrypt filter=git-agecrypt diff=git-agecrypt
```
