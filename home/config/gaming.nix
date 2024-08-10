{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    moonlight-qt
  ];
}
