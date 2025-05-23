{ nixosProfiles, ... }:
{
  imports = with nixosProfiles; [
    system.common.basic
    system.disko.luks-btrfs
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "sdhci_pci" "rtsx_usb_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  disko.devices = {
    disk.main.device = "/dev/disk/by-path/pci-0000:02:00.0-nvme-1";
    nodev."/".mountOptions = [ "size=4G" ];
  };

  hardware.cpu.intel.updateMicrocode = true;
}
