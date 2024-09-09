{ config, lib, ... }:
with lib; let
  cfg = config.custom.programs.kitty;
  portals = config.custom.portals;
  theme = config.custom.misc.theme;
in {
  options.custom.programs.kitty = {
    enable = mkEnableOption "kitty";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "monospace";
        size = 12.0;
      };
      settings = mkMerge [
        {
          shell = "${portals.shell.command}";
          window_padding_width = "0";
          window_border_width = "0";
          background_opacity = "0.85";
          hide_window_decorations = "yes";
          confirm_os_window_close = "0";
          enable_audio_bell = "no";
          window_alert_on_bell = "no";
          map = "kitty_mod+t no_op";
        }
        (mkIf theme.enable (let
          palette = theme.inUse.base24Theme;
        in {
          foreground = "#${palette.base05}";
          background = "#${palette.base00}";
          color0 = "#${palette.base00}";
          color1 = "#${palette.base08}";
          color2 = "#${palette.base0B}";
          color3 = "#${palette.base0A}";
          color4 = "#${palette.base0D}";
          color5 = "#${palette.base0E}";
          color6 = "#${palette.base0C}";
          color7 = "#${palette.base05}";
          color8 = "#${palette.base03}";
          color9 = "#${palette.base08}";
          color10 = "#${palette.base0B}";
          color11 = "#${palette.base0A}";
          color12 = "#${palette.base0D}";
          color13 = "#${palette.base0E}";
          color14 = "#${palette.base0C}";
          color15 = "#${palette.base07}";
        }))
      ];
    };
  };
}
