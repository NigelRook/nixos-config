{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../common/secure-boot.nix
    ./alder-lake-n.nix
    ../../config/kubernetes-resources.nix
    ./nas
  ];

  boot.loader.systemd-boot = {
    consoleMode = "2";
    editor = false;
  };
}
