{ config, lib, ... }:
with lib; let
  cfg = config.custom.hm-nixos;
  hm-nixosUserOpts = {
    options.enable = mkEnableOption "nixos config from home-manager";
  };
  mapUserPresist = username: usercfg: {
    files = config.home-manager.users.${username}.envPersist.files;
    directories = config.home-manager.users.${username}.envPersist.directories;
  };
in {
  options.custom.hm-nixos = mkOption {
    type = types.attrsOf (types.submodule hm-nixosUserOpts);
    default = { };
  };
  config = {
    environment.persistence."/persist".users = mapAttrs mapUserPresist cfg;
  };
}
