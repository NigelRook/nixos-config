{ pkgs, lib, ... }:
{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.firefox.enable = true;

  programs.coolercontrol.enable = true;

  programs.chromium.enable = true;

  environment.systemPackages = with pkgs; [
    (vivaldi.override {
      commandLineArgs = [
        "--flag-switches-begin"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--enable-features=DefaultANGLEVulkan,Vulkan,VulkanFromANGLE"
        "--flag-switches-end"
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime=true"
        "--enable-features=AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations"
      ];
    })
    ungoogled-chromium
    discord
  ];

  home-manager.users.nigel.services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
