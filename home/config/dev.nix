{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.editorconfig.editorconfig
      pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "window.menuBarVisibility" = "compact";
      "window.titleBarStyle" = "custom";
      "editor.renderWhitespace" = "all";
    };
  };
}
