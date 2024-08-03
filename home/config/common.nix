{ ... }:

{
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

  # home.packages = with pkgs; [
  # ];

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
      "Makefile" = {
        indent_style = "tab";
        indent_size = 4;
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

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
