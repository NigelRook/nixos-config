{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ./alder-lake-n.nix
    ../../config/kubernetes-resources.nix
    ./nas.nix
  ];
}
