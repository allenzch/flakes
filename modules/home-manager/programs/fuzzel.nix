{ config, lib, mypkgs, ... }:
with lib; let cfg = config.custom.programs.fuzzel;
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
        colors = {
          background = "${config.colorScheme.palette.base00}ee";
          text = "${config.colorScheme.palette.base05}ff";
          match = "${config.colorScheme.palette.base0D}ff";
          selection = "${config.colorScheme.palette.base04}ff";
          selection-text = "${config.colorScheme.palette.base05}ff";
          selection-match = "${config.colorScheme.palette.base0D}ff";
          border = "${config.colorScheme.palette.base0D}ff";
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