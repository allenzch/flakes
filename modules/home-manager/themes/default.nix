{ config, lib, pkgs, nix-colors, mylib, ... } @args: 
with lib; let 
  cfg = config.custom.theme;
in {
  options.custom.theme = {
    enable = mkEnableOption "theme";
    variant = mkOption {
      type = types.enum [ "light" "dark" ];
      default = "dark";
    };
  };

  config = mkIf cfg.enable (mkMerge (
    [{
      home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        roboto-mono
        (nerdfonts.override { fonts = [ "RobotoMono" ]; })
      ];
    }
    {
      fonts.fontconfig = {
        enable = true;
        defaultFonts.sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
          "Noto Color Emoji"
        ];
        defaultFonts.serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
          "Noto Color Emoji"
        ];
        defaultFonts.monospace = [
          "RobotoMono Nerd Font Mono"
          "Noto Sans Mono"
          "Noto Sans Mono CJK SC"
          "Noto Color Emoji"
        ];
        defaultFonts.emoji = [
          "Noto Color Emoji"
        ];
      };
      home.pointerCursor = {
        light = {
          name = "catppuccin-latte-blue-cursors";
          package = pkgs.catppuccin-cursors.latteBlue;
          size = 32;
          gtk.enable = true;
        };
        dark = {
          name = "catppuccin-macchiato-blue-cursors";
          package = pkgs.catppuccin-cursors.macchiatoBlue;
          size = 32;
          gtk.enable = true;
        };
      }.${cfg.variant};
      wayland.windowManager.sway.config.seat."*" = {
        xcursor_theme = "${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}";
      };
      colorScheme =  {
        light = nix-colors.colorSchemes.catppuccin-latte;
        dark = nix-colors.colorSchemes.catppuccin-macchiato;
      }.${cfg.variant};
      dconf.settings."org/gnome/desktop/interface".color-scheme = {
        light = "prefer-light";
        dark = "prefer-dark";
      }.${cfg.variant};
      home.packages = with pkgs; [
        (writeShellApplication {
          name = "tt";
          runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
          text = ''
            "$(home-manager generations | head -1 | rg -o '/[^ ]*')"/specialisation/dark-theme/activate && swww img ~/wallpapers/light
          '';
        })
      ];
      specialisation.dark-theme.configuration = {
        custom.theme.variant = "light";
        home.packages = with pkgs; [
          (hiPrio (writeShellApplication {
            name = "tt";
            runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
            text = ''
              "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate && swww img ~/wallpapers/dark
            '';
          }))
        ];
      };
    }]
    ++ (map (path: import path args) (mylib.getItemPaths ./. "default.nix"))
  ));
}
