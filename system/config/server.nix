{ pkgs, ... }:
{
  imports = [ ./kubernetes.nix ];

  users.users.nigel.openssh.authorizedKeys.keys = [
    # boyd
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJn2MzlgP2GCi2oMb3nYc/onyI4lSQxNgUPO3gP8PXp6"
  ];

  environment.systemPackages = with pkgs; [
    kubectl
  ];
}
