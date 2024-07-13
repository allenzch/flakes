{ config, lib, ... }:
with lib; let cfg = config.custom.layers.bareBase;
in {
  options.custom.layers.bareBase = {
    enable = mkEnableOption "basic utilities";
  };
  config = mkIf cfg.enable {
    custom.programs = {
      fish.enable = true;
      yazi.enable = true;
      htop.enable = true;
    };
  };
}