{ ... }:
{
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_SG.UTF-8";

  users.mutableUsers = false;

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
