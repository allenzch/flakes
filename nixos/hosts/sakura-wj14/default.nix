{ nixosProfiles, ... }: {
  imports = with nixosProfiles; [
    system.common.desktop
  ];

  boot = {
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "usbcore.autosuspend=-1" ];
  };

  disko.devices = {
    disk.main.device = "/dev/disk/by-path/pci-0000:03:00.0-nvme-1";
    nodev."/".mountOptions = [ "size=4G" ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
      KEYBOARD_KEY_3a=esc
      KEYBOARD_KEY_01=capslock

  '';

  systemd.network = {
    networks = {
      "20-wlan0" = {
        name = "wlan0";
        DHCP = "yes";
      };
    };
  };

  services.enthalpy = {
    prefix = "2a0e:aa07:e21d:2630::/60";
    ipsec.interfaces = [ "wlan0" ];
    clat = {
      enable = true;
      segment = [ "2a0e:aa07:e21c:2546::3" ];
    };
  };

  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;
  services.logind.lidSwitch = "ignore";
}
