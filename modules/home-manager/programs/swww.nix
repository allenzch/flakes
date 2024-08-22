{ config, lib, pkgs, ... }:
with lib; let cfg = config.custom.programs.swww;
in {
  options.custom.programs.swww = {
    enable = mkEnableOption "swww";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ swww ];
    envPersist.directories = [
      "wallpapers"
    ];
  };
}
