{ config, lib, pkgs, inputs, ... }:
let
  inherit (lib.meta) getExe;
  cfg = config.programs.niri;
  themeDir = "${config.home.homeDirectory}/${config.theme.themesDir}/niri";
in
{
  imports = [
    inputs.niri-flake.homeModules.niri
    ./binds.nix
    ./portal.nix
    ./programs.nix
  ];

  programs.niri.package = pkgs.niri-unstable;

  programs.niri.settings = {
    input.touchpad = {
      tap = true;
      natural-scroll = true;
      dwt = true;
    };
    hotkey-overlay.skip-at-startup = true;
    prefer-no-csd = true;
    window-rules = [{
      geometry-corner-radius = 
      let
        radius = 0.0;
      in {
        bottom-left = radius;
        bottom-right = radius;
        top-left = radius;
        top-right = radius;
      };
      clip-to-geometry = true;
      draw-border-with-background = false;
    }];
    layout = {
      gaps = 16;
      default-column-width = { proportion = 1.0 / 2.0; };
    };
    spawn-at-startup = [
      { argv = [ "bash" "-c" "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" ]; }
    ];
    includes = [
      "${themeDir}/noctalia_theme.kdl"
      "${themeDir}/cursor.kdl"
    ];
  };

  home.packages = with pkgs; [
    cfg.package
    (writeShellApplication {
      name = "wayland-session";
      runtimeInputs = [ cfg.package ];
      text = ''
        niri-session
      '';
    })
  ];

  services.darkman = let
    mkScript = mode: let
      cursorCfg = pkgs.writeText "cursor.kdl" ''
        cursor {
          xcursor-theme "${config.theme.${mode}.cursorTheme}"
          xcursor-size ${config.theme.${mode}.cursorSize}
        }
      '';
    in pkgs.writeShellApplication {
      name = "darkman-switch-niri-cursor-${mode}";
      text = ''
        ln --force --symbolic --verbose ${cursorCfg} ${themeDir}/cursor.kdl
      '';
    };
  in {
    lightModeScripts.niri = "${getExe (mkScript "light")}";
    darkModeScripts.niri = "${getExe (mkScript "dark")}";
  };
}
