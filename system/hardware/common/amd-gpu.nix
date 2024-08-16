{ pkgs, lib, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  hardware.amdgpu.initrd.enable = lib.mkDefault true;
}
