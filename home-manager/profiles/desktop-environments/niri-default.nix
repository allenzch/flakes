{ pkgs, homeProfiles, ... }: {
  home.packages = with pkgs; [
    systemd-run-app
    nautilus
    file-roller
    loupe
    papers
    mpv
    libreoffice
  ];
  imports = with homeProfiles.programs; [
    kitty
    fuzzel
    swaylock
    firefox
    swww
    waybar
  ];
  custom = {
    misc = {
      theme.enable = true;
      fontconfig.enable = true;
      gtk.enable = true;
    };
    services = {
      niri = {
        enable = true;
        config.binds = {
          "Mod+Return" = { spawn = [ "systemd-run-app" "kitty" ]; };
          "Mod+T" = { spawn = [ "systemd-run-app" "kitty" ]; };
          "Mod+D" = { spawn = [ "fuzzel" ]; };
          "Mod+Shift+M" = { spawn = [ "swaylock" ]; };
          "Mod+W" = { spawn = [ "systemd-run-app" "firefox" ]; };
          "Mod+E" = { spawn = [ "nautilus" ]; };
          "Mod+V" = { spawn = [ "cliphist-fuzzel" ]; };
        };
      };
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = 1;
}
