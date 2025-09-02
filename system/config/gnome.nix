{ pkgs, lib, ... }:
{
  users.users.nigel-gnome = {
    isNormalUser = true;
    description = "Nigel Rook (Gnome)";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "changeme";
    createHome = true;
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = (with pkgs; [
    gnome-tweaks
    dconf-editor
    ptyxis
    blanket
    (rewaita.overrideAttrs (finalAttrs: prevAttrs: {
      version = "1.0.7";
      src = fetchFromGitHub {
        owner = "SwordPuffin";
        repo = "Rewaita";
        tag = "v1.0.7";
        hash = "sha256-adSXq+DFw3IQxNuUkP1FcKlIh9h4Zb0tJKswYs3S92E=";
      };
    }))
    nodejs_latest
    nodePackages.sass
  ]) ++ (with pkgs.gnomeExtensions; [
    hibernate-status-button
    appindicator
    clipboard-history
    arcmenu
    blur-my-shell
    dash-to-panel
    gsconnect
    caffeine
    night-theme-switcher
    notification-banner-reloaded
    user-themes
    dash-to-dock
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
            experimental-features = ["variable-refresh-rate"];
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
              arcmenu.extensionUuid
              blur-my-shell.extensionUuid
              dash-to-panel.extensionUuid
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

          "org/gnome/shell/extensions/hibernate-status-button" = {
            show-hybrid-sleep = false;
            show-suspend-then-hibernate = false;
          };

          "org/gnome/shell/extensions/arcmenu" = {
            application-shortcuts=[
              [
                (mkDictionaryEntry "name" "Settings")
                (mkDictionaryEntry "icon" "org.gnome.Settings")
                (mkDictionaryEntry "id" "org.gnome.Settings.desktop")
              ]
              [
                (mkDictionaryEntry "name" "Tweaks")
                (mkDictionaryEntry "icon" "org.gnome.tweaks")
                (mkDictionaryEntry "id" "org.gnome.tweaks.desktop")
              ]
              [
                (mkDictionaryEntry "name" "Terminal")
                (mkDictionaryEntry "icon" "org.gnome.Ptyxis")
                (mkDictionaryEntry "id" "org.gnome.Ptyxis.desktop")
              ]
              [
                (mkDictionaryEntry "name" "Activities Overview")
                (mkDictionaryEntry "icon" "view-fullscreen-symbolic")
                (mkDictionaryEntry "id" "ArcMenu_ActivitiesOverview")
              ]
              [
                (mkDictionaryEntry "name" "Extension Manager")
                (mkDictionaryEntry "icon" "com.mattjakeman.ExtensionManager")
                (mkDictionaryEntry "id" "com.mattjakeman.ExtensionManager.desktop")
              ]
            ];
            # #application-shortcuts-list=@aas []
            button-item-icon-size="Small";
            custom-menu-button-icon-size=23.0;
            disable-recently-installed-apps=true;
            #distro-icon=6;
            extra-categories=[
              (mkTuple [(mkInt32 0) true])
              (mkTuple [(mkInt32 1) true])
              (mkTuple [(mkInt32 2) true])
              (mkTuple [(mkInt32 3) true])
              (mkTuple [(mkInt32 4) false])
            ];
            #menu-background-color="#262830";
            #menu-border-color="rgb(60,60,60)";
            #menu-button-active-fg-color=(mkTuple [true, "rgb(26,95,180)"]);
            menu-button-appearance="Icon";
            menu-button-border-radius=mkTuple [true (mkInt32 25)];
            #menu-button-fg-color=(false, 'rgb(26,95,180)')
            #menu-button-icon='Distro_Icon'
            menu-button-position-offset=mkInt32 0;
            #menu-foreground-color='#e0e0e8'
            #menu-item-active-bg-color='#004397'
            #menu-item-active-fg-color=' #d6e2ff'
            menu-item-grid-icon-size="Medium";
            #menu-item-hover-bg-color=' #004397'
            #menu-item-hover-fg-color=' #d6e2ff'
            menu-layout="Raven";
            #menu-separator-color='rgba(255,255,255,0.1)'
            #override-menu-theme=true
            #pinned-app-list=@as []
            pinned-apps=[
              [
                (mkDictionaryEntry "name" "Firefox")
                (mkDictionaryEntry "id" "firefox.desktop")
              ]
              [
                (mkDictionaryEntry "name" "Steam")
                (mkDictionaryEntry "id" "steam.desktop")
              ]
              [
                (mkDictionaryEntry "name" "VS Code")
                (mkDictionaryEntry "id" "code.desktop")
              ]
              [
                (mkDictionaryEntry "name" "Files")
                (mkDictionaryEntry "id" "org.gnome.Nautilus.desktop")
              ]
            ];
            prefs-visible-page=mkInt32 0;
            search-entry-border-radius=mkTuple [true (mkInt32 25)];
            shortcut-icon-type="Full_Color";
          };

          "org/gnome/shell/extensions/dash-to-panel" = {
            animate-appicon-hover=false;
            animate-appicon-hover-animation-extent=[
              (mkDictionaryEntry "RIPPLE" (mkInt32 4))
              (mkDictionaryEntry "PLANK" (mkInt32 4))
              (mkDictionaryEntry "SIMPLE" (mkInt32 1))
            ];
            animate-appicon-hover-animation-type="PLANK";
            appicon-margin=mkInt32 8;
            appicon-padding=mkInt32 4;
            available-monitors=[(mkInt32 0)];
            dot-position="BOTTOM";
            hotkeys-overlay-combo="TEMPORARILY";
            isolate-workspaces=true;
            leftbox-padding=mkInt32 (-1);
            panel-anchors=''{"0":"MIDDLE"}'';
            panel-element-positions=''{"0":[{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'';
            panel-lengths=''{"0":100}'';
            panel-sizes=''{"0":48}'';
            primary-monitor=mkInt32 0;
            status-icon-padding=mkInt32 (-1);
            stockgs-keep-dash=false;
            stockgs-keep-top-panel=false;
            stockgs-panelbtn-click-only=false;
            trans-panel-opacity=0.20000000000000001;
            trans-use-custom-gradient=false;
            trans-use-custom-opacity=true;
            trans-use-dynamic-opacity=true;
            tray-padding=mkInt32 (-1);
            window-preview-title-position="TOP";
          };
        };
      }];
    };
  };
}
