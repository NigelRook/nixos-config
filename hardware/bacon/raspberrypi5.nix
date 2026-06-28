{ nixos-raspberrypi, lib, ... }:
{
  imports = with nixos-raspberrypi.nixosModules; [
    # Required: Add necessary overlays with kernel, firmware, vendor packages
    nixos-raspberrypi.lib.inject-overlays

    # Binary cache with prebuilt packages for the currently locked `nixpkgs`,
    # see `devshells/nix-build-to-cachix.nix` for a list
    trusted-nix-caches

    # Optional: All RPi and RPi-optimised packages to be available in `pkgs.rpi`
    nixpkgs-rpi

    raspberry-pi-5.base
    raspberry-pi-5.page-size-16k
    raspberry-pi-5.bluetooth
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.loader.raspberry-pi.bootloader = "kernel";

  # Fix for pam_ssh_agent_auth on aarch64-linux, see
  # https://github.com/NixOS/nixpkgs/issues/386392
  nixpkgs.overlays = [
    (final: prev: {
      pam_ssh_agent_auth = prev.pam_ssh_agent_auth.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            ${prev.patchelf}/bin/patchelf \
              --add-needed libgcc_s.so.1 \
              --add-rpath ${prev.stdenv.cc.cc.lib}/lib \
              $out/libexec/pam_ssh_agent_auth.so
          '';
      });
    })
  ];
}
