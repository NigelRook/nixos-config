{ pkgs, ... }:
{
  sops.secrets."homelab/disk-key" = {
    owner = "nigel";
  };

  systemd.services.unlock-data-disks = {
    description = "Unlock secondary data disks with sops secret";
    after = [ "sops-nix.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "unlock-and-mount" ''
      ${pkgs.cryptsetup}/bin/cryptsetup open --key-file /run/secrets/homelab/disk-key /dev/disk/by-uuid/6e3088aa-37b3-4982-aa0e-b84d256dfd4f hdd-1-ironwolf-18T
      ${pkgs.systemd}/bin/systemctl start srv-hdd_1_ironwolf_18T.mount
    '';
    };
  };
}
