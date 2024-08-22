{ config, lib, ... }:
with lib; let cfg = config.custom.programs.htop;
in {
  options.custom.programs.htop = {
    enable = mkEnableOption "htop";
  };
  config = mkIf cfg.enable {
    programs.htop.enable = true;
  };
}
