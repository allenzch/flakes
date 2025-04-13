{ ... }:
{
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
