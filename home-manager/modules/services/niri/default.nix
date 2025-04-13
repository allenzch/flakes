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
  
          "Mod+H" = { focus-column-left = [ ]; };
          "Mod+L" = { focus-column-right = [ ]; };
          "Mod+Shift+H" = { move-column-left = [ ]; };
          "Mod+Shift+K" = { move-window-up = [ ]; };
          "Mod+Ctrl+H" = { consume-or-expel-window-left = [ ]; };
          "Mod+Ctrl+L" = { consume-or-expel-window-right = [ ]; };
          "Mod+C" = { center-column = [ ]; };
          "Mod+J" = { focus-window-down = [ ]; };
          "Mod+K" = { focus-window-up = [ ]; };
          "Mod+Shift+J" = { move-window-down = [ ]; };
          "Mod+Shift+L" = { move-column-right = [ ]; };

          "Mod+U" = { focus-workspace-down = [ ]; };
          "Mod+I" = { focus-workspace-up = [ ]; };
          "Mod+Shift+U" = { move-column-to-workspace-down = [ ]; };
          "Mod+Shift+I" = { move-column-to-workspace-up = [ ]; };
          "Mod+Ctrl+U" = { move-workspace-down = [ ]; };
          "Mod+Ctrl+I" = { move-workspace-up = [ ]; };
          "Mod+7" = { focus-monitor-left = [ ]; };
          "Mod+8" = { focus-monitor-down = [ ]; };
          "Mod+9" = { focus-monitor-up = [ ]; };
          "Mod+0" = { focus-monitor-right = [ ]; };
          "Mod+Shift+7" = { move-column-to-monitor-left = [ ]; };
          "Mod+Shift+8" = { move-column-to-monitor-down = [ ]; };
          "Mod+Shift+9" = { move-column-to-monitor-up = [ ]; };
          "Mod+Shift+0" = { move-column-to-monitor-right = [ ]; };
  
          "Mod+R" = { switch-preset-column-width = [ ]; };
          "Mod+Shift+R" = { reset-window-height = [ ]; };
          "Mod+F" = { maximize-column = [ ]; };
          "Mod+Shift+F" = { fullscreen-window = [ ]; };
          "Mod+Minus" = { set-column-width = "-10%"; };
          "Mod+Equal" = { set-column-width = "+10%"; };
          "Mod+Shift+Minus" = { set-window-height = "-10%"; };
          "Mod+Shift+Equal" = { set-window-height = "+10%"; };
  
          "Mod+S" = { screenshot = [ ]; };
          "Mod+Shift+S" = { screenshot-window = [ ]; };
          "Mod+M" = { power-off-monitors = [ ]; };
  
          "Mod+Shift+Q" = { close-window = [ ]; };
          "Mod+Shift+Ctrl+Q" = { quit = [ ]; };
          "Mod+Shift+Slash" = { show-hotkey-overlay = [ ]; };
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
