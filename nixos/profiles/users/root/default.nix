{
  config,
  lib,
  self,
  ...
}:
{
  users.users.root.hashedPasswordFile =
    config.sops.secrets."user-password/root".path;

  sops.secrets."user-password/root" = {
    neededForUsers = true;
    sopsFile = lib.mkDefault "${self}/secrets/local.yaml";
  };
}
