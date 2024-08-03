{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        pkgs.gnome-browser-connector
      ];
    };
    profiles.default = {
      search = {
        default = "DuckDuckGo";
        force = true;
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
      ];
      settings = {
        "apz.fling_friction" = 0.005;
        "apz.fling_min_velocity_threshold" = 1.5;
        "signon.rememberSignons" = false;
      };
    };
  };
}
