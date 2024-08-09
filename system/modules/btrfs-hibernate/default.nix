{ config, pkgs, lib, ... }:
{
  options = {
    btrfs-hibernate = {
      swapFilePath = lib.mkOption {
        type = lib.types.path;
        description = "Path to the swap file to be used for hibernation";
      };
      swapFileOffsetCalculator = lib.mkOption {
        type = lib.types.package;
      };
      swapFileOffset = lib.mkOption {
        type = lib.types.ints.unsigned;
        description = "Offset of the swap file sued for hibernation";
      };
    };
  };

  config = {
    nix.settings.extra-sandbox-paths = [ "/.swapvol" ];
    nix.settings.sandbox = "relaxed";

    btrfs-hibernate.swapFileOffsetCalculator = pkgs.stdenv.mkDerivation rec {
      pname = "swapfile-offset-calculator";
      version = "0.1.0";

      __noChroot = true;

      buildInputs = [ pkgs.btrfs-progs ];

      phases = [ "buildPhase" "installPhase" ];

      buildPhase = ''
        echo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
        btrfs inspect-internal map-swapfile -r /.swapvol/swapfile > offset
      '';

      installPhase = ''
        mkdir -p $out
        cp offset $out/
      '';
    };

    btrfs-hibernate.swapFileOffset = lib.strings.toIntBase10 (
      builtins.readFile (config.btrfs-hibernate.swapFileOffsetCalculator + "/offset"));

    boot.kernelParams = [
      "resume_offset=${toString config.btrfs-hibernate.swapFileOffset}"
    ];
  };
}
