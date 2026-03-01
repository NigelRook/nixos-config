{ pkgs, lib, config, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = (with pkgs; [
    gnome-tweaks
    dconf-editor
    ptyxis
    blanket
  ]) ++ (with pkgs.gnomeExtensions; [
    hibernate-status-button
    appindicator
    clipboard-history
    blur-my-shell
    gsconnect
    caffeine
    night-theme-switcher
    paperwm
  ]);

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    simple-scan
    gnome-weather
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-console
  ];

  programs.dconf.profiles = {
    user = {
      enableUserDb = true;
      databases = [{
        settings = with lib.gvariant; {
          "org/gnome/mutter" = {
            dynamic-workspaces = true;
            experimental-features = ["scale-monitor-framebuffer" "kms-modifiers" "variable-refresh-rate"];
          };

          "org/gnome/system/location" = {
            enabled = true;
          };

          "org/gnome/settings-daemon/plugins/power" = {
            ambient-enabled = false;
            idle-brightness = mkInt32 100;
            idle-dim = false;
          };

          "org/gnome/Console" = {
            audible-bell = false;
            theme = "auto";
          };

          "org/gnome/desktop/interface" = {
            enable-hot-corners = false;
          };

          "org/gnome/desktop/wm/keybindings" = {
            toggle-fullscreen = [ "<Super>F11" ];
          };

          "org/gnome/desktop/background" = {
            picture-uri = "file://${../files/wallpaper.png}";
            picture-uri-dark = "file://${../files/wallpaper.png}";
          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = "file://${../files/wallpaper.png}";
            lock-delay = mkUint32 1800;
          };

          "org/gnome/shell" = {
            disable-extension-version-validation=true;
            enabled-extensions = with pkgs.gnomeExtensions; [
              hibernate-status-button.extensionUuid
              appindicator.extensionUuid
              clipboard-history.extensionUuid
              gsconnect.extensionUuid
              caffeine.extensionUuid
              night-theme-switcher.extensionUuid
            ];
            favorite-apps = [
              "firefox.desktop"
              "steam.desktop"
              "code.desktop"
              "org.gnome.Ptyxis.desktop"
            ];
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = false;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/shell/extensions/hibernate-status-button" = {
            show-hybrid-sleep = false;
            show-suspend-then-hibernate = false;
          };

          "org/gnome/shell/extensions/gsconnect" = {
            name = config.networking.hostName;
          };

          "org/gnome/shell/extensions/nightthemeswitcher/time" = {
            manual-schedule = false;
          };
        };
      }];
    };
  };
}
