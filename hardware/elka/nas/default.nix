{
  imports = [
    ./filesystems.nix
    ./nfs.nix
    ./samba.nix
  ];

  services.k3s.nodeLabel = [
    "nas=true"
  ];
}
