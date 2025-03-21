{ pkgs, config }: {
  height = 24;
  layer = "top";
  "custom/nixos" = {
    format = "";
    interval = "once";
    tooltip = false;
  };
  modules-left = [
    "custom/nixos"
    "wlr/taskbar"
  ];
  modules-right = [
    "idle_inhibitor"
    "pulseaudio"
    "memory"
    "temperature"
    "battery"
    "clock"
    "tray"
  ];
  "wlr/taskbar" = {
    format = "{icon}";
    tooltip-format = "{title}";
    on-click = "activate";
    on-click-middle = "close";
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
  tray = {
    icon-size = 18;
    spacing = 10;
  };
}
