{ pkgs, ... }:
{
  services.k3s = {
    enable = true;
    gracefulNodeShutdown.enable = true;
  };

  environment.systemPackages = [ pkgs.kubectx ];
}
