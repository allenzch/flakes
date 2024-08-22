{ config, lib, pkgs, ... }:
with lib; let cfg = config.custom.programs.telegram;
in {
  options.custom.programs.telegram = {
    enable = mkEnableOption "telegram";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
