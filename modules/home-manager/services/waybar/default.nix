{ config, pkgs, lib, ... }:
with lib; let
  cfg = config.custom.services.waybar;
  theme = config.custom.misc.theme;
in {
  options.custom.services.waybar = {
    enable = mkEnableOption "waybar";
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.waybar = {
        enable = true;
        settings = [ (import ./waybar.nix { inherit config pkgs; }) ];
        style = import ./style.nix { inherit theme; };
        systemd.enable = true;
      };
    }
  ]);
}
