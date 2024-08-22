{ config, lib, pkgs, ... }:
with lib; let cfg = config.custom.programs.waybar;
in {
  options.custom.programs.waybar = {
    enable = mkEnableOption "waybar";
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      systemd.enable = true;
      enable = true;
      settings = [{
        height = 24;
        layer = "top";
        "custom/nixos" = {
          format = "";
          interval = "once";
          tooltip = false;
        };
        modules-left = [
          "custom/nixos"
          "sway/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "network"
          "idle_inhibitor"
          "pulseaudio"
          "memory"
          "temperature"
          "battery"
          "clock"
          "tray"
        ];
        "sway/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };
        "sway/window" = {
          format = "{}";
          all-outputs = true;
          max-length = 60;
          offscreen-css = true;
          offscreen-css-text = "(inactive)";
        };
        network = {
          format = "{essid}";
        };
        idle_inhibitor = {
          format = "{icon} ";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        pulseaudio = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "󰂯 {volume}% {format_source}";
          format-bluetooth-muted = "󰝟 {volume}% {format_source}";
          format-icons = {
            headphone = "󰋋";
            default = [ "󰖀" "󰕾" ];
          };
          format-muted = "󰝟 {volume}% {format_source}";
          format-source = " {volume}%";
          format-source-muted = " {volume}%";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        clock = {
          format = "{:%a %b %d %H:%M}";
        };
        memory = {
          format = " {percentage}%";
        };
        temperature = {
          format = " {temperatureC}°C";
          interval = 10;
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        };
        battery = {
          format = "󰁹 {capacity}%";
          format-charging =  "󰁹 {capacity}% (charging)";
          format-plugged = "󰁹 {capacity}% (plugged)"; 
        };
        tray = {
          icon-size = 18;
          spacing = 10;
        };
      }];
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: 'RobotoMono Nerd Font', 'sans';
          font-size: 12pt;
          font-weight: normal;
          min-height: 0;
          color: #${config.colorScheme.palette.base05};
        }

        window#waybar {
          padding: 0pt;
          opacity: 0.95;
          color: #${config.colorScheme.palette.base05};
          background: #${config.colorScheme.palette.base00};
          border-bottom: 2pt solid #${config.colorScheme.palette.base02};
        }

        window#waybar.hidden {
          opacity: 0.0;
        }

        #workspaces button {
          padding: 0pt;
          background: transparent;
          color: #${config.colorScheme.palette.base05};
          border-bottom: 2pt solid transparent;
        }

        #workspaces button.focused,
        #workspaces button.active {
          background: #${config.colorScheme.palette.base02};
          border-bottom: 2pt solid #${config.colorScheme.palette.base07};
        }

        #workspaces button.urgent {
          background: #${config.colorScheme.palette.base0A};
        }

        #custom-nixos {
          padding-left: 12pt;
          padding-right: 15pt;
        }

        #mode,
        #window {
          padding: 0pt 8pt;
        }

        #idle_inhibitor,
        #tray,
        #pulseaudio,
        #network,
        #backlight,
        #temperature,
        #memory,
        #cpu,
        #battery,
        #clock {
          margin: 0pt 0pt;
          padding: 0pt 8pt;
        }

        #idle_inhibitor,
        #tray,
        #pulseaudio,
        #network,
        #backlight,
        #temperature,
        #memory,
        #cpu,
        #battery,
        #clock {
          border-left: 2pt solid #${config.colorScheme.palette.base02};
        }
      '';
    };
  };
}
