{ config, lib, ... }:
with lib; let
  cfg = config.custom.programs.foot;
  portals = config.custom.portals;
  theme = config.custom.theme;
in {
  options.custom.programs.foot = {
    enable = mkEnableOption "foot";
  };
  config = mkIf cfg.enable {
    programs.foot = {
      enable = false;
      settings = {
        main = {
          shell = "${portals.shell.command}";
          font = "monospace:size=12";
          dpi-aware = "no";
        };
        colors = mkMerge [
          { alpha = "0.95"; }
          mkIf theme.enable {
            foreground = "${config.colorScheme.palette.base05}";
            background = "${config.colorScheme.palette.base00}";
            regular0 = "${config.colorScheme.palette.base00}";
            regular1 = "${config.colorScheme.palette.base08}";
            regular2 = "${config.colorScheme.palette.base0B}";
            regular3 = "${config.colorScheme.palette.base0A}";
            regular4 = "${config.colorScheme.palette.base0D}";
            regular5 = "${config.colorScheme.palette.base0E}";
            regular6 = "${config.colorScheme.palette.base0C}";
            regular7 = "${config.colorScheme.palette.base05}";
            bright0 = "${config.colorScheme.palette.base03}";
            bright1 = "${config.colorScheme.palette.base08}";
            bright2 = "${config.colorScheme.palette.base0B}";
            bright3 = "${config.colorScheme.palette.base0A}";
            bright4 = "${config.colorScheme.palette.base0D}";
            bright5 = "${config.colorScheme.palette.base0E}";
            bright6 = "${config.colorScheme.palette.base0C}";
            bright7 = "${config.colorScheme.palette.base07}";
          }
        ];
        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
