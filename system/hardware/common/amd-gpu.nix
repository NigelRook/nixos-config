{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";
}
