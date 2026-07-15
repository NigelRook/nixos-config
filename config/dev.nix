{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
    git-agecrypt
    vscode
    nixd
    nix-diff
    deploy-rs
    kubectl
    kubectx
    kubectl-cnpg
    kubernetes-helm
    pv-migrate
    k9s
    argocd
  ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  users.users.nigel = {
    extraGroups = [ "libvirtd" ];
  };

  sops.secrets."users/nigel/admin-key" = {
    owner = "nigel";
  };

  home-manager.users.nigel.home = {
    sessionVariables.SOPS_AGE_KEY_FILE = config.sops.secrets."users/nigel/admin-key".path;
  };
}
