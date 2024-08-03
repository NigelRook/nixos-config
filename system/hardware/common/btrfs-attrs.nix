{
  fileSystems."/".options = [ "noatime" "nodiratime" ];

  fileSystems."/.snapshots".options = [ "noatime" "nodiratime" ];

  fileSystems."/.swapvol".options = [ "noatime" "nodiratime" ];

  fileSystems."/home".options = [ "noatime" "nodiratime" ];

  fileSystems."/nix".options = [ "noatime" "nodiratime" ];

  fileSystems."/var/log".options = [ "noatime" "nodiratime" ];
}
