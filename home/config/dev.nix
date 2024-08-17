{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixd
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      editorconfig.editorconfig
      streetsidesoftware.code-spell-checker
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "window.menuBarVisibility" = "compact";
      "window.titleBarStyle" = "custom";
      "editor.renderWhitespace" = "all";
      "window.autoDetectColorScheme" = true;
    };
  };
}
