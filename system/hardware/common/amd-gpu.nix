{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.hardware = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32bit = [ pkgs.driversi686Linux.amdvlk ];
  };

  hardware.opengl.driSupport32Bit = true;
}
