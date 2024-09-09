{ config, lib, mypkgs, ... }:
with lib; let
  cfg = config.custom.programs.fuzzel;
  theme = config.custom.misc.theme;
in {
  options.custom.programs.fuzzel = {
    enable = mkEnableOption "fuzzel";
  };
  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          launch-prefix = "systemd-run-app";
        };
        colors = let
          palette = theme.inUse.base24Theme; 
        in {
          background = "${palette.base00}ee";
          text = "${palette.base05}ff";
          match = "${palette.base0D}ff";
          selection = "${palette.base04}ff";
          selection-text = "${palette.base05}ff";
          selection-match = "${palette.base0D}ff";
          border = "${palette.base0D}ff";
        };
        border = {
          width = "2";
          radius = "0";
        };
      };
    };
    home.packages = [
      mypkgs.systemd-run-app
    ];
  };
}
