{ nixosProfiles, ... }:
{
  imports = with nixosProfiles; [
    system.common.basic
    system.disko.luks-btrfs
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "xhci_pci_renesas" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
  };

  disko.devices = {
    disk.main.device = "/dev/disk/by-id/nvme-Predator_SSD_GM7_2TB_PSAH55430518164";
    disk.data = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD6004FZBX-00C9FA0_WD-AQ00GMAM";
      content = {
        type = "gpt";
        partitions.data = {
          label = "DATA";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes."/data" = {
              mountpoint = "/persist/hdd";
              mountOptions = [ "compress=zstd" "noatime" ];
            };
          };
        };
      };
    };
    nodev."/".mountOptions = [ "size=32G" ];
  };

  hardware.cpu.amd.updateMicrocode = true;
}
