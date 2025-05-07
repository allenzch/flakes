{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in {
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
