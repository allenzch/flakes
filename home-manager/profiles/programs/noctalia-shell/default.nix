{ lib, pkgs, data, ... }:
let
  inherit (lib.meta) getExe;
in
{
  home.packages = [ pkgs.noctalia-shell ];

  xdg.configFile = {
    "noctalia" = {
      source = ./config;
      recursive = true;
      force = true;
    };
  };

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell - Wayland desktop shell";
      Documentation = "https://docs.noctalia.dev/docs";
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = getExe pkgs.noctalia-shell;
      Restart = "on-failure";
      Environment = [
        "QT_QPA_PLATFORMTHEME=gtk3"
        "NOCTALIA_REALNAME=${data.noctalia-shell.displayName}"
      ];
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  persistence.directories = [
    ".config/noctalia"
  ];
}
