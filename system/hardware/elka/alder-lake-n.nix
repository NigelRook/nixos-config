{ config, lib, pkgs, ... }:
{
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.kernelModules = [ "i915" ];

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime
    vpl-gpu-rt
  ];

  hardware.graphics.extraPackages32 = [ pkgs.intel-media-driver-32 ];
}
