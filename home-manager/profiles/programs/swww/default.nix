{ config, pkgs, lib, wallpapers, ... }:
with lib;
let
  theme = config.misc.theme;
in
{
  options.services.swww = {
    wallpaper = mkOption {
      type = types.path;
      default = "${wallpapers}/wallhaven-x6871l.png";
      description = "path to the wallpaper";
    };
  };

  config = mkMerge [
    {
      xdg.configFile."swww/wallpaper" = {
        source = config.services.swww.wallpaper;
        onChange = ''
          if ${config.systemd.user.systemctlPath} --user is-active --quiet swww-daemon; then
            ${pkgs.swww}/bin/swww img ~/.config/swww/wallpaper
          fi
        '';
      };
    }
    {
      systemd.user.services.swww-daemon = {
        Unit = {
          Description = "A Solution to your Wayland Wallpaper Woes";
          Documentation = "https://github.com/LGFae/swww";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.swww}/bin/swww-daemon --no-cache";
          ExecStartPost = "${pkgs.swww}/bin/swww img ${config.home.homeDirectory}/.config/swww/wallpaper";
          Restart = "on-failure";
          KillMode = "mixed";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    }
    (mkIf theme.enable {
      services.swww = {
        inherit (theme.inUse) wallpaper;
      };
    })
  ];
}
