{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixd
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      editorconfig.editorconfig
      arrterian.nix-env-selector
      streetsidesoftware.code-spell-checker
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      ms-python.python
    ];
    userSettings = {
      "files.autoSave" = "onFocusChange";
      "window.menuBarVisibility" = "compact";
      "window.titleBarStyle" = "custom";
      "editor.renderWhitespace" = "all";
      "window.autoDetectColorScheme" = true;
    };
  };

  programs.git.extraConfig = {
    init = {
      defaultBranch = "main";
    };
  };
}
