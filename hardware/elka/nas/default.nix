{
  imports = [
    ./filesystems.nix
    ./nfs.nix
    ./samba.nix
    ./folders.nix
  ];

  services.k3s.nodeLabel = [
    "nas=true"
  ];
}
