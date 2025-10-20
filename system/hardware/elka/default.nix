{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ./alder-lake-n.nix
    ./master-vm.nix
  ];
}
