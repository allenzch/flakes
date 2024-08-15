{ config, lib, ... }:
with lib; let
  cfg = config.custom.programs.direnv;
in {
  options.custom.programs.direnv = {
    enable = mkEnableOption "direnv";
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
