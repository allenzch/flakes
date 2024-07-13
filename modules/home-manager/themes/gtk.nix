{ config, pkgs, ... }:
let
  cfg = config.custom.theme;
in {
  gtk = {
    enable = true;
    # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    iconTheme = {
      light = {
        name = "Tela-blue";
        package = pkgs.tela-icon-theme;
      };
      dark = {
        name = "Tela-blue";
        package = pkgs.tela-icon-theme;
      };
    }.${cfg.variant};
    theme = {
      light = {
        name = "catppuccin-latte-blue-compact";
        package = pkgs.catppuccin-gtk.override {
          size = "compact";
          variant = "latte";
        };
      };
      dark = {
        name = "catppuccin-macchiato-blue-compact";
        package = pkgs.catppuccin-gtk.override {
          size = "compact";
          variant = "macchiato";
        };
      };
    }.${cfg.variant};
    gtk3.extraCss = ''
      .titlebar { border-radius: 0; }
    '';
  };
}
