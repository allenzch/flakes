{ config, lib, pkgs, nixosProfiles, ... }:
let
  inherit (lib) mkDefault;
in {
  imports = with nixosProfiles; [
    services.logrotate
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      kernelModules = [ ];
      systemd.enable = true;
    };
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
    tmp.useTmpfs = true;
  };

  hardware.enableRedistributableFirmware = true;

  systemd.suppressedSystemUnits = [
    "systemd-machine-id-commit.service"
  ];

  time.timeZone = "Asia/Singapore";

  i18n.defaultLocale = "en_SG.UTF-8";

  users.mutableUsers = false;

  services.userborn = {
    enable = true;
    passwordFilesLocation = "/var/lib/nixos/userborn";
  };

  nix = {
    enable = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;
      flake-registry = "";
    };
    registry.p.to = {
      type = "path";
      path = config.nixpkgs.flake.source;
    };
  };

  networking = {
    useDHCP = false;
    useNetworkd = false;
  };

  sops = {
    age = {
      keyFile = "/var/lib/nixos/sops-nix/sops.key";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
