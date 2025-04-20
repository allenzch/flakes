{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in {
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    tmp.useTmpfs = true;
  };

  time.timeZone = "Asia/Singapore";

  i18n.defaultLocale = "en_SG.UTF-8";

  users.mutableUsers = false;

  services.userborn = {
    enable = true;
    passwordFilesLocation = "/var/lib/nixos";
  };

  systemd.suppressedSystemUnits = [
    "systemd-machine-id-commit.service"
  ];

  sops = {
    age = {
      keyFile = "/persist/sops.key";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
  };
}
