{ pkgs, ... }:
{
  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm.enable = true;

    displayManager.sddm.wayland.enable = true;
  };

  # Disable fingerprint login - it slows kde login
  security.pam.services.login.fprintAuth = false;

  environment.systemPackages = with pkgs; [kdePackages.koi];
}
