{ pkgs, ... }: {
  custom = {
    misc = {
      theme.enable = true;
      fontconfig.enable = true;
      gtk.enable = true;
    };
    programs = {
      kitty.enable = true;
      fuzzel.enable = true;
      swaylock.enable = true;
      firefox.enable = true;
    };
    services = {
      niri = {
        enable = true;
        config.binds = {
          "Mod+Return" = { spawn = [ "systemd-run-app" "kitty" ]; };
          "Mod+D" = { spawn = [ "fuzzel" ]; };
          "Mod+M" = { spawn = [ "swaylock" ]; };
          "Mod+W" = { spawn = [ "systemd-run-app" "firefox" ]; };
        };
      };
      waybar.enable = true;
      swww.enable = true;
    };
  };
}
