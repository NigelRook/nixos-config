{ config, pkgs, ... }:
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
      extensions = with config.nur.repos.rycee.firefox-addons; [
        bitwarden
        ublock-origin
      ];
      settings = {
        "apz.fling_friction" = 0.005;
        "apz.fling_min_velocity_threshold" = 1.5;
        "browser.sessionstore.max_resumed_crashes" = -1;
        "signon.rememberSignons" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "privacy.donottrackheader.enabled" = true;
        "services.sync.engine.addons" = false;
        "services.sync.engine.bookmarks" = false;
        "services.sync.engine.prefs" = false;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
