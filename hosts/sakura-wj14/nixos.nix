{ config, lib, pkgs, modulesPath, nixpkgs-wayland, impermanence, nix-colors, nixosModules, hmModules, mylib, mypkgs, data, pkgs-stable, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
  ];

  custom = {
    security.sudo = {
      enable = true;
      enableVarPersistence = true;
    };
    networking.wireless.iwd = {
      enable = true;
      enableVarPersistence = true;
    };
    virtualisation.podman.enable = true;
    hm-nixos.allen.enable = true;
  };

  nixpkgs = {
    overlays = [ nixpkgs-wayland.overlay ];
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      permittedInsecurePackages = [
        "electron-27.3.11"
      ];
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
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

  systemd.suppressedSystemUnits = [
    "systemd-machine-id-commit.service"
  ];

  powerManagement.powertop.enable = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_SG.UTF-8";
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
    users.allen = {
      hashedPasswordFile = "/persist/hashed/allen";
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
    settings = rec {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --cmd ${pkgs.writeShellScript "sway" ''
	  exec systemd-cat --identifier=sway sway -D legacy-wl-drm
	''}";
      };
    };
  };

  programs = {
    dconf.enable = true;
    steam = {
      enable = true;
    };
    fish.enable = true;
  };
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.allen = {
      imports = [
        impermanence.nixosModules.home-manager.impermanence
        nix-colors.homeManagerModules.default
        hmModules
        ./users/allen.nix
      ];
    };
    extraSpecialArgs = {
      inherit nix-colors;
      inherit mylib;
      inherit mypkgs;
      inherit data;
      inherit pkgs-stable;
    };
  };
}
