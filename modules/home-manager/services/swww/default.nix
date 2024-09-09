{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.custom.services.swww;
  theme = config.custom.misc.theme;
in
{
  options.custom.services.swww = {
    enable = mkEnableOption "swww wallpaper daemon";
    package = mkPackageOption pkgs "swww" { };
    wallpaper = mkOption {
      type = types.path;
      description = "path to the wallpaper";
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        xdg.configFile."swww/wallpaper" = {
          source = cfg.wallpaper;
          onChange = ''
            if ${config.systemd.user.systemctlPath} --user is-active --quiet swww-daemon; then
              ${cfg.package}/bin/swww img ~/.config/swww/wallpaper
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
            ExecStart = "${cfg.package}/bin/swww-daemon --no-cache";
            ExecStartPost = "${cfg.package}/bin/swww img ${config.home.homeDirectory}/.config/swww/wallpaper";
            Restart = "on-failure";
            KillMode = "mixed";
          };

          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      }
      (mkIf theme.enable {
        custom.services.swww = {
          inherit (theme.inUse) wallpaper;
        };
      })
    ]
  );
}
