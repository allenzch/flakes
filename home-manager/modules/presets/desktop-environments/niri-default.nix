{ pkgs, mypkgs, ... }: {
  home.packages = with pkgs; [
    mypkgs.systemd-run-app
    nautilus
    file-roller
    loupe
    papers
    mpv
  ];
  imports = [
    ../../../profiles/kitty.nix
    ../../../profiles/fuzzel.nix
    ../../../profiles/swaylock.nix
    ../../../profiles/firefox.nix
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
          "Mod+M" = { spawn = [ "swaylock" ]; };
          "Mod+W" = { spawn = [ "systemd-run-app" "firefox" ]; };
          "Mod+E" = { spawn = [ "nautilus" ]; };
          "Mod+V" = { spawn = [ "cliphist-fuzzel" ]; };
        };
      };
      waybar.enable = true;
      swww.enable = true;
    };
  };
}
