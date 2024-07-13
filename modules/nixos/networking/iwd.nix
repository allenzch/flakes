{ config, lib, ... }:
with lib; let cfg = config.custom.networking.wireless.iwd;
in {
  options.custom.networking.wireless.iwd = {
    enable = mkEnableOption "iwd";
    enableVarPersistence = mkEnableOption "persistence of variable data files for iwd";
  };
  config = mkIf cfg.enable {
    networking.wireless.iwd.enable = true;
    environment.persistence."/persist" = mkIf cfg.enableVarPersistence {
      directories = [ "/var/lib/iwd" ];
    };
  };
}