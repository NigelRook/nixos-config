{
  services.nfs.server = {
    enable = true;
    exports = ''
      /export       192.168.2.0/24(fsid=0,crossmnt)
      /export/media 192.168.2.0/24(fsid=1,rw,sync,no_wdelay,insecure,anonuid=1000,anongid=1000,all_squash)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
