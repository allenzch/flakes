{ config, ... }:
{
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    open = false;
  };
  boot = {
    kernelParams = [
      "nvidia_drm.fbdev=1"
      #"nvidia.NVreg_EnablePCIeGen3=1"
      #"nvidia.NVreg_UsePageAttributeTable=1"
    ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
