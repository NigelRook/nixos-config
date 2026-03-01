{ ... }:
{
  imports = [ ./kubernetes.nix ];

  users.users.nigel.openssh.authorizedKeys.keys = [
    # boyd
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJn2MzlgP2GCi2oMb3nYc/onyI4lSQxNgUPO3gP8PXp6"
  ];

  security.pam.sshAgentAuth.enable = true;
  security.pam.services.sudo.sshAgentAuth = true;

  programs.screen.enable = true;
}
