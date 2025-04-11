{ config, lib, pkgs, modulesPath, inputs, impermanence, nixosProfiles, homeModules, homeProfiles, mylib, mypkgs, data, pkgs-stable, ... }: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disko.nix
    ] ++
    (with nixosProfiles; [
      networking.iwd
      security.sudo
      security.hardware-keys
      system.common
      services.enthalpy
      system.nixpkgs
    ]);

  custom = {
    hm-nixos.allenzch.enable = true;
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
    };
    bluetooth.enable = true;
  };

  powerManagement.powertop.enable = true;
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  networking = {
    hostName = "sakura-wj14";
    useDHCP = false;
    useNetworkd = false;
  };



  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks = {
      "20-wlan0" = {
        name = "wlan0";
        DHCP = "yes";
      };
    };
  };

  services = {
    power-profiles-daemon.enable = true;
    logind.lidSwitch = "ignore";
    resolved.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    udev.extraHwdb = ''
      evdev:atkbd:dmi:*
        KEYBOARD_KEY_3a=esc
        KEYBOARD_KEY_01=capslock
      
      evdev:input:b*v046Dp4089*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock

      evdev:input:b*v258Ap1006*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock
    '';
    enthalpy = {
      prefix = "2a0e:aa07:e21d:2630::/60";
      ipsec.interfaces = [ "wlan0" ];
      clat = {
        enable = true;
        segment = [ "2a0e:aa07:e21c:2546::3" ];
      };
    };
    proxy = {
      enable = true;
      inbounds = [
        {
          netnsPath = config.networking.netns.enthalpy.netnsPath;
          listenPort = config.networking.netns.enthalpy.ports.proxy-init-netns;
        }
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;

  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
  ];

  sops.secrets = {
    "user-password/allenzch" = {
      neededForUsers = true;
      sopsFile = ../../secrets/local.yaml;
    };
  };
  users = {
    users.allenzch = {
      hashedPasswordFile = config.sops.secrets."user-password/allenzch".path;
      isNormalUser = true;
      extraGroups = [ "wheel" "video" ];
      shell = pkgs.fish;
    };
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/logrotate.status"
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --cmd ${pkgs.writeShellScript "sway" ''
	  exec systemd-cat --identifier=sway sway -D legacy-wl-drm
	''}";
      };
    };
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
  };
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.allenzch = {
      imports = [
        impermanence.nixosModules.home-manager.impermanence
        ./users/allenzch.nix
      ] ++ homeModules;
    };
    extraSpecialArgs = {
      inherit mylib;
      inherit mypkgs;
      inherit data;
      inherit inputs;
      inherit pkgs-stable;
      inherit homeProfiles;
    };
  };

  systemd.services.nix-daemon = config.networking.netns.enthalpy.config;

  systemd.services."user@1000" =
    config.networking.netns.enthalpy.config
    // {
      overrideStrategy = "asDropin";
      restartIfChanged = false;
    };
}
