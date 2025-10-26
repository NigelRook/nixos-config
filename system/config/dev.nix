{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscode
    nixd
    nix-diff
    deploy-rs
    kubectl
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
}
