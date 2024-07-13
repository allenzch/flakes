{ config, lib, ... }:
with lib; let
  cfg = config.custom.programs.swaylock;
in
{
  options.custom.programs.swaylock = {
    enable = mkEnableOption "swaylock";
  };

  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;
        daemonize = true;
        color = "000000";
      };
    };
  };
}