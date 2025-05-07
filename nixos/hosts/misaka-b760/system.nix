{ nixosProfiles, ... }: {
  imports = with nixosProfiles; [
    system.common.desktop
    hardware.nvidia-graphics
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  disko.devices = {
    disk.main.device = "/dev/disk/by-path/pci-0000:02:00.0-nvme-1";
    nodev."/".mountOptions = [ "size=8G" ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  systemd.network.networks = {
    "20-eno1" = {
      name = "eno1";
      DHCP = "yes";
    };
    "20-wlan0" = {
      name = "wlan0";
      DHCP = "yes";
    };
  };

  services = {
    enthalpy = {
      prefix = "2a0e:aa07:e21d:2620::/60";
      ipsec.interfaces = [ "eno1" ];
      clat = {
        enable = true;
        segment = [ "2a0e:aa07:e21c:2546::3" ];
      };
    };
  };
}
