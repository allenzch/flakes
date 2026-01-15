{ config, pkgs, inputs, ... }:
let
  inherit (config.misc.theme.inUse) cursorTheme;
  cfg = config.programs.niri;
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
    cursor = {
      theme = cursorTheme.name;
      size = cursorTheme.size;
    };
    spawn-at-startup = [
      { argv = [ "bash" "-c" "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" ]; }
    ];
    includes = [ "${config.home.homeDirectory}/.config/niri/noctalia.kdl" ];
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
}
