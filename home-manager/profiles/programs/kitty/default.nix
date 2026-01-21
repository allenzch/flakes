{ config, lib, pkgs, ... }:
let
  inherit (lib.meta) getExe;
  themeDir = "${config.home.homeDirectory}/${config.theme.themesDir}/kitty";
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "monospace";
      size = 12.0;
    };
    settings = {
      cursor_trail = "1";
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = "2";
      shell = ".";
      window_padding_width = "0";
      window_border_width = "0";
      background_opacity = "0.85";
      hide_window_decorations = "yes";
      confirm_os_window_close = "0";
      enable_audio_bell = "no";
      window_alert_on_bell = "no";
    };
    keybindings = {
      "kitty_mod+t" = "no_op";
      "ctrl+tab" = "launch";
    };
    extraConfig = ''
      include ${themeDir}/theme.conf
      include ${themeDir}/noctalia_theme.conf
    '';
  };

  services.darkman = let
    mkScript = mode: pkgs.writeShellApplication {
      name = "darkman-switch-kitty-${mode}";
      runtimeInputs = with pkgs; [
        procps
      ];
      text = ''
        ln --force --symbolic --verbose ${config.theme.${mode}.kittyTheme} ${themeDir}/theme.conf
        pkill -USR1 -u "$USER" kitty || true
      '';
    };
  in {
    lightModeScripts.kitty = "${getExe (mkScript "light")}";
    darkModeScripts.kitty = "${getExe (mkScript "dark")}";
  };
}
