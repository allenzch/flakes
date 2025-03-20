{ config, ... }:
{
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."user-password/root".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrBKIBvt+ktGk0wfGC6dXB3AhH/kq7lgrCNNV7l5fWj allenzch@misaka-b760"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNDUqt2SdN4i2lt5HiAOfIDxZSCgRcatL5OdXaEM2Xk allenzch@sakura-wj14"
    ];
  };

  sops.secrets."user-password/root" = {
    neededForUsers = true;
    sopsFile = ../../../../secrets/local.yaml;
  };
}
