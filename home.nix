{ inputs, config, pkgs, lib, ... }:

{
  home.username = "nigel";
  home.homeDirectory = "/home/nigel";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  home.packages = with pkgs; [
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/Console" = {
        font-scale = lib.mkDefault 1.1;
        audible-bell = false;
      };
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell".favorite-apps = [
        "firefox.desktop"
        "code.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 120;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Nigel Rook";
    userEmail = "nigelrook@gmail.com";
  };

  programs.starship = {
    enable = true;
    settings = {
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
    '';
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      mouse = "a";
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };
  };

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

  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.editorconfig.editorconfig
    ];
    userSettings = {
      "files.autosave" = "onFocusChange";
    };
  };

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
