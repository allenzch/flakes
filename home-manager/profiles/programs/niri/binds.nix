{ pkgs, ... }:
{
  programs.niri.settings.binds = {
    "Mod+H".action.focus-column-left = [];
    "Mod+L".action.focus-column-right = [];
    "Mod+J".action.focus-workspace-down = [];
    "Mod+K".action.focus-workspace-up = [];
    "Mod+Shift+H".action.move-column-left = [];
    "Mod+Shift+L".action.move-column-right = [];
    "Mod+Shift+J".action.move-column-to-workspace-down = [];
    "Mod+Shift+K".action.move-column-to-workspace-up = [];
    "Mod+Ctrl+J".action.move-window-down = [];
    "Mod+Ctrl+K".action.move-window-up = [];
    "Mod+grave".action.toggle-overview = [];

    "Mod+F".action.maximize-column = [];
    "Mod+Shift+F".action.maximize-window-to-edges = [];
    "Mod+Ctrl+F".action.fullscreen-window = [];
    "Mod+Minus".action.set-column-width = [ "-10%" ];
    "Mod+Equal".action.set-column-width = [ "+10%" ];

    "XF86AudioMute".action.spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--toggle-mute" ];
    "XF86AudioLowerVolume".action.spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "-5" ];
    "XF86AudioRaiseVolume".action.spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "+5" ];
    "XF86AudioPlay".action.spawn = [ "${pkgs.playerctl}/bin/playerctl" "play-pause" ];
    "XF86AudioPrev".action.spawn = [ "${pkgs.playerctl}/bin/playerctl" "previous" ];
    "XF86AudioNext".action.spawn = [ "${pkgs.playerctl}/bin/playerctl" "next" ];
    "Mod+Shift+P".action.spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--toggle-mute" ];
    "Mod+Shift+BracketLeft".action.spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "-5" ];
    "Mod+Shift+BracketRight".action.spawn = [ "${pkgs.pulsemixer}/bin/pulsemixer" "--change-volume" "+5" ];
    "Mod+P".action.spawn = [ "${pkgs.playerctl}/bin/playerctl" "play-pause" ];
    "Mod+BracketLeft".action.spawn = [ "${pkgs.playerctl}/bin/playerctl" "previous" ];
    "Mod+BracketRight".action.spawn = [ "${pkgs.playerctl}/bin/playerctl" "next" ];

    "Mod+Return".action.spawn = "kitty";
    "Mod+T".action.spawn = "kitty";
    "Mod+D".action.spawn = "fuzzel";
    "Mod+M".action.spawn = "swaylock";
    "Mod+E".action.spawn = "nautilus";
    "Mod+W".action.spawn = "firefox";

    "Print".action.screenshot-screen = { show-pointer = false; };
    "Mod+S".action.screenshot = { show-pointer = false; };
    "Mod+Shift+S".action.screenshot-window = [];
    "Mod+Ctrl+S".action.screenshot-screen = { show-pointer = false; };
    "Mod+Shift+Q".action.close-window = [];
    "Mod+Shift+Ctrl+Q".action.quit = [];
    "Mod+Slash".action.show-hotkey-overlay = [];
  };
}
