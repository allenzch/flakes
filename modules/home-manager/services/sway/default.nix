{ config, lib, mypkgs, pkgs, ... }:
with lib; let
  cfg = config.custom.services.sway;
  portals = config.custom.portals;
  theme = config.custom.theme;
  modifier = config.wayland.windowManager.sway.config.modifier;
  screenshotUtility = pkgs.writeShellApplication {
    name = "swayshot";
    text = ''
      ${pkgs.grim}/bin/grim -g "$(swaymsg -t get_tree | ${pkgs.jq}/bin/jq -r '(.. | (.nodes? // empty)[] | select(.type == "con" and .visible) | .rect | "\(.x),\(.y - 27) \(.width)x\(.height + 27)"), (.rect | "\(.x), \(.y) \(.width)x\(.height)")' | ${pkgs.slurp}/bin/slurp -c '#ff0000ff')" - | ${pkgs.wl-clipboard}/bin/wl-copy
    '';
  };
in {
  options.custom.services.sway = {
    enable = mkEnableOption "sway";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      systemd = {
        enable = true;
      };
      wrapperFeatures.gtk = true;
      config = {
        window.border = 2;
        gaps = {
          outer = 0;
          inner = 8;
          bottom = 4;
          left = 4;
          right = 4;
        };
        input = {
          "2362:597:UNIW0001:00_093A:0255_Touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
        };
        output = {
          eDP-1 = {
            scale = "1.5";
          };
        };
        modifier = "Mod4";
        modes = {
          resize = {
            Escape = "mode default";
            Return = "mode default";
            "${modifier}+r" = "mode default";
            h = "resize shrink width 10 px";
            j = "resize grow height 10 px";
            k = "resize shrink height 10 px";
            l = "resize grow width 10 px";
          };
        };
        keybindings = mkMerge [
          {
            "${modifier}+r" = "mode resize";
            "${modifier}+s" = "exec systemd-run-app ${screenshotUtility}/bin/swayshot";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+q" = "split toggle";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+a" = "floating toggle";
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+Tab" = "workspace next";
            "${modifier}+Shift+Tab" = "workspace prev";
            "${modifier}+1" = "workspace 1";
            "${modifier}+2" = "workspace 2";
            "${modifier}+3" = "workspace 3";
            "${modifier}+4" = "workspace 4";
            "${modifier}+5" = "workspace 5";
            "${modifier}+6" = "workspace 6";
            "${modifier}+7" = "workspace 7";
            "${modifier}+8" = "workspace 8";
            "${modifier}+9" = "workspace 9";
            "${modifier}+Shift+1" = "move container to workspace 1; workspace 1";
            "${modifier}+Shift+2" = "move container to workspace 2; workspace 2";
            "${modifier}+Shift+3" = "move container to workspace 3; workspace 3";
            "${modifier}+Shift+4" = "move container to workspace 4; workspace 4";
            "${modifier}+Shift+5" = "move container to workspace 5; workspace 5";
            "${modifier}+Shift+6" = "move container to workspace 6; workspace 6";
            "${modifier}+Shift+7" = "move container to workspace 7; workspace 7";
            "${modifier}+Shift+8" = "move container to workspace 8; workspace 8";
            "${modifier}+Shift+9" = "move container to workspace 9; workspace 9";
          }
          (mkIf portals.terminal.enable { "${modifier}+Return" = "exec systemd-run-app ${portals.terminal.command}"; })
          (mkIf portals.launcher.enable { "${modifier}+d" = "exec systemd-run-app ${portals.launcher.command}"; })
          (mkIf portals.browser.enable { "${modifier}+w" = "exec systemd-run-app ${portals.browser.command}"; })
          { "${modifier}+m" = "exec swaylock"; }
        ];
        startup = [
          { command = "swww-daemon --format xrgb"; }
          { command = "swww img ~/wallpapers/${config.custom.theme.variant}"; }
        ];
        bars = [ ];
        fonts = {
          names = [ "monospace" ];
          size = 10.5;
        };
        colors = {
          focused = {
            border = "${config.colorScheme.palette.base0D}";
            background = "${config.colorScheme.palette.base00}";
            childBorder = "${config.colorScheme.palette.base0D}";
            indicator = "#2e9ef4";
            text = "${config.colorScheme.palette.base05}";
          };
        };
      };
      extraConfig = ''
        titlebar_border_thickness 2
      '';
    };
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    # dependencies
    home.packages = [
      mypkgs.systemd-run-app
    ];
    custom.programs = {
      swaylock.enable = true;
    };
  };
}
