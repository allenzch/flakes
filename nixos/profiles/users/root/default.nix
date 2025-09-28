{ config, self, ... }:
{
  users.users.root = {
    hashedPasswordFile = config.sops.secrets."user-password/root".path;
  };

  sops.secrets."user-password/root" = {
    neededForUsers = true;
    sopsFile = "${self}/secrets/local.yaml";
  };
}
