{ config, self, ... }:
{
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."user-password/root".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrBKIBvt+ktGk0wfGC6dXB3AhH/kq7lgrCNNV7l5fWj"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNDUqt2SdN4i2lt5HiAOfIDxZSCgRcatL5OdXaEM2Xk"
    ];
  };

  sops.secrets."user-password/root" = {
    neededForUsers = true;
    sopsFile = "${self}/secrets/local.yaml";
  };
}
