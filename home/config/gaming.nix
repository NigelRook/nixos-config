{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    moonlight-qt
  ];

  # Override moonlight .desktop to add -platform wayland (needed for hardware decoding)
  xdg.desktopEntries."com.moonlight_stream.Moonlight.desktop" = {
    name = "Moonlight";
    comment = "Stream games and other applications from another PC running Sunshine or GeForce Experience";
    exec = "moonlight -platform wayland";
    icon = "moonlight";
    terminal = false;
    categories = [ "Qt" "Game" ];
    settings = {
      Keywords = "nvidia;gamestream;stream;sunshine;remote play;";
    };
  };
}
