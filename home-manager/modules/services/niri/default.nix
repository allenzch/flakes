{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.custom.services.niri;
  theme = config.custom.misc.theme;
  configFile = pkgs.writeTextFile {
    name = "niri-config.kdl";
    text = (lib.hm.generators.toKDL { } cfg.config) + "\n" + cfg.extraConfig;
    checkPhase = ''
      ${cfg.package}/bin/niri validate -c "$target"
    '';
  };
in
{
  options.custom.services.niri = {
    enable = mkEnableOption "niri configuration";
    package = mkPackageOption pkgs "niri" { };
    checkConfig = mkOption {
      type = types.bool;
      default = true;
      description = "If enabled (the default), validates the generated config file.";
    };
    screenshotPath = mkOption {
      type = types.str;
      default = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      description = ''
        The path where screenshots are saved. The path is formatted with
        strftime(3) to give you the screenshot date and time.
      '';
    };
    config = mkOption {
      type = with types; attrsOf anything;
      default = { };
      description = "Niri configuration options.";
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to {file}`config.kdl`.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      custom.services.niri.extraConfig = ''
        spawn-at-startup "bash" "-c" "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
      '';
  
      custom.services.niri.config = {
        input = {
          touchpad = {
            tap = [ ];
            dwt = [ ];
            natural-scroll = [ ];
          };
        };
        binds = {
          "XF86AudioMute" = { spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--toggle-mute" ]; };
          "XF86AudioLowerVolume" = { spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "-5" ]; };
          "XF86AudioRaiseVolume" = { spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "+5" ]; };
          "Mod+Shift+P" = { spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--toggle-mute" ]; };
          "Mod+Shift+BracketLeft" = { spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "-5" ]; };
          "Mod+Shift+BracketRight" = { spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "+5" ]; };
          "XF86AudioPlay" = { spawn = [ "${pkgs.playerctl}/bin/playerctl" "play-pause" ]; };
          "XF86AudioPrev" = { spawn = [ "${pkgs.playerctl}/bin/playerctl" "previous" ]; };
          "XF86AudioNext" = { spawn = [ "${pkgs.playerctl}/bin/playerctl" "next" ]; };
          "Mod+P" = { spawn = [ "${pkgs.playerctl}/bin/playerctl" "play-pause" ]; };
          "Mod+BracketLeft" = { spawn = [ "${pkgs.playerctl}/bin/playerctl" "previous" ]; };
          "Mod+BracketRight" = { spawn = [ "${pkgs.playerctl}/bin/playerctl" "next" ]; };
  
          "Mod+1" = { focus-workspace = 1; };
          "Mod+2" = { focus-workspace = 2; };
          "Mod+3" = { focus-workspace = 3; };
          "Mod+4" = { focus-workspace = 4; };
          "Mod+5" = { focus-workspace = 5; };
          "Mod+6" = { focus-workspace = 6; };
          "Mod+7" = { focus-workspace = 7; };
          "Mod+8" = { focus-workspace = 8; };
          "Mod+9" = { focus-workspace = 9; };
          "Mod+Shift+1" = { move-column-to-workspace = 1; };
          "Mod+Shift+2" = { move-column-to-workspace = 2; };
          "Mod+Shift+3" = { move-column-to-workspace = 3; };
          "Mod+Shift+4" = { move-column-to-workspace = 4; };
          "Mod+Shift+5" = { move-column-to-workspace = 5; };
          "Mod+Shift+6" = { move-column-to-workspace = 6; };
          "Mod+Shift+7" = { move-column-to-workspace = 7; };
          "Mod+Shift+8" = { move-column-to-workspace = 8; };
          "Mod+Shift+9" = { move-column-to-workspace = 9; };
          "Mod+U" = { focus-workspace-down = [ ]; };
          "Mod+I" = { focus-workspace-up = [ ]; };
          "Mod+Shift+U" = { move-column-to-workspace-down = [ ]; };
          "Mod+Shift+I" = { move-column-to-workspace-up = [ ]; };
          "Mod+Ctrl+U" = { move-workspace-down = [ ]; };
          "Mod+Ctrl+I" = { move-workspace-up = [ ]; };
  
          "Mod+H" = { focus-column-left = [ ]; };
          "Mod+J" = { focus-window-down = [ ]; };
          "Mod+K" = { focus-window-up = [ ]; };
          "Mod+L" = { focus-column-right = [ ]; };
          "Mod+Shift+H" = { move-column-left = [ ]; };
          "Mod+Shift+J" = { move-window-down = [ ]; };
          "Mod+Shift+K" = { move-window-up = [ ]; };
          "Mod+Shift+L" = { move-column-right = [ ]; };
          "Mod+Q" = { consume-or-expel-window-left = [ ]; };
          "Mod+A" = { consume-or-expel-window-right = [ ]; };
          "Mod+C" = { center-column = [ ]; };
  
          "Mod+R" = { switch-preset-column-width = [ ]; };
          "Mod+Shift+R" = { reset-window-height = [ ]; };
          "Mod+F" = { maximize-column = [ ]; };
          "Mod+Shift+F" = { fullscreen-window = [ ]; };
          "Mod+Minus" = { set-column-width = "-10%"; };
          "Mod+Equal" = { set-column-width = "+10%"; };
          "Mod+Shift+Minus" = { set-window-height = "-10%"; };
          "Mod+Shift+Equal" = { set-window-height = "+10%"; };
  
          "Mod+Shift+S" = { screenshot = [ ]; };
          "Mod+Ctrl+S" = { screenshot-window = [ ]; };
  
          "Mod+Shift+E" = { quit = [ ]; };
          "Mod+Shift+Q" = { close-window = [ ]; };
          "Mod+Shift+Slash" = { show-hotkey-overlay = [ ]; };
  
          "Mod+Ctrl+H" = { focus-monitor-left = [ ]; };
          "Mod+Ctrl+J" = { focus-monitor-down = [ ]; };
          "Mod+Ctrl+K" = { focus-monitor-up = [ ]; };
          "Mod+Ctrl+L" = { focus-monitor-right = [ ]; };
          "Mod+Shift+Ctrl+H" = { move-column-to-monitor-left = [ ]; };
          "Mod+Shift+Ctrl+J" = { move-column-to-monitor-down = [ ]; };
          "Mod+Shift+Ctrl+K" = { move-column-to-monitor-up = [ ]; };
          "Mod+Shift+Ctrl+L" = { move-column-to-monitor-right = [ ]; };
  
          "Mod+N" = { power-off-monitors = [ ]; };
        };
        prefer-no-csd = [ ];
        screenshot-path = cfg.screenshotPath;
        hotkey-overlay = { skip-at-startup = [ ]; };
        window-rule = {
          geometry-corner-radius = 0;
          clip-to-geometry = true;
          draw-border-with-background = false;
        };
        layout = {
          border = { off = [ ]; };
          default-column-display = [ "tabbed" ];
          tab-indicator = { hide-when-single-tab = [ ]; };
        };
      };
  
      home.packages = with pkgs; [
        cfg.package
        xdg-utils
      ];
  
      xdg.configFile."niri/config.kdl".source = configFile;
  
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        config = {
          common = {
            "default" = [ "gnome" "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
        xdgOpenUsePortal = true;
      };
    }
    (mkIf theme.enable {
      custom.services.niri.extraConfig = ''
        cursor {
          xcursor-theme "${theme.inUse.cursorTheme.name}"
          xcursor-size ${toString theme.inUse.cursorTheme.size}
        }
      '';
    })
  ]);
}
