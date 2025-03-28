{ config, lib, pkgs, modulesPath, inputs, nixpkgs, impermanence, nix-colors, nixosProfiles, homeModules, homeProfiles, mylib, mypkgs, data, pkgs-stable, ... }: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./disko.nix
    ] ++
    (with nixosProfiles; [
      hardware.nvidia
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
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
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
      kernelModules = [ ];
      availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
    };
    bluetooth.enable = true;
  };

  sops = {
    secrets = {
      "user-password/allenzch" = {
        neededForUsers = true;
        sopsFile = ../../secrets/local.yaml;
      };
    };
  };
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      flake-registry = "";
    };
    registry = {
      nixpkgs.flake = nixpkgs;
      home-manager.flake = inputs.home-manager;
    };
  };

  networking = {
    hostName = "misaka-b760";
    useDHCP = false;
    useNetworkd = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks = {
      "20-eno1" = {
        name = "eno1";
        DHCP = "yes";
      };
      "20-wlan0" = {
        name = "wlan0";
        DHCP = "yes";
      };
    };
  };

  services = {
    resolved.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
    };
    udev.extraHwdb = ''
      evdev:input:b*v046Dp4089*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock

      evdev:input:b*v1A81p2039*
        KEYBOARD_KEY_70039=esc
        KEYBOARD_KEY_70029=capslock
    '';
    enthalpy = {
      prefix = "2a0e:aa07:e21d:2620::/60";
      ipsec.interfaces = [ "eno1" ];
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
        nix-colors.homeManagerModules.default
        ./users/allenzch.nix
      ] ++ homeModules;
    };
    extraSpecialArgs = {
      inherit nix-colors;
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
