{ config, lib, ...  }:
with lib; let cfg = config.custom.security.sudo;
in {
  options.custom.security.sudo = {
    enable = mkEnableOption "sudo";
    enableVarPersistence = mkEnableOption "persistence of per-user lecture status files";
  };
  config = mkIf cfg.enable {
    security.sudo.enable = true;
    environment.persistence."/persist" = mkIf cfg.enableVarPersistence {
      directories = [ "/var/db/sudo" ];
    };
  };
}