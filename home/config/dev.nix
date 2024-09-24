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
      github.copilot
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      ms-python.python
      golang.go
    ];
    mutableExtensionsDir = false;
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

  home.file."~/.config/libvirt/qemu.conf".text = ''
    nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
  '';
}
