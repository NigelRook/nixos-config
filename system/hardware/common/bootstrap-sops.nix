{ lib, ... }:
{
  sops.age.keyFile = lib.mkForce "/tmp/sops/key.txt";
}
