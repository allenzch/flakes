{ config, lib, pkgs, modulesPath, inputs, nixpkgs, impermanence, nix-colors, nixosProfiles, hmModules, homeProfiles, mylib, mypkgs, data, pkgs-stable, ... }: {
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

  systemd.suppressedSystemUnits = [
    "systemd-machine-id-commit.service"
  ];

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_SG.UTF-8";

  sops = {
    secrets = {
      "user-password/allenzch" = {
        neededForUsers = true;
        sopsFile = ../../secrets/local.yaml;
      };
    };
    age = {
      keyFile = "/persist/sops.key";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
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
        address = [ "10.26.254.1/16" ];
        gateway = [ "10.26.1.3" ];
        dns = [ "10.26.1.2" ];
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
    mutableUsers = false;
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
        hmModules
        ./users/allenzch.nix
      ];
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
}
