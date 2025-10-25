{ pkgs, lib, ... }:
let
  inherit (lib) singleton;
  fcitx5Package = pkgs.qt6Packages.fcitx5-with-addons.override {
    addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
    ];
    withConfigtool = true;
  };
in
{
  config = {
    home.packages = singleton fcitx5Package;

    persistence.directories = singleton  ".config/fcitx5";

    systemd.user.services.fcitx5-daemon = {
      Unit = {
        Description = "Fcitx5 input method editor";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        Requiste = [ "graphical-session.target" ];
      };
      Service.ExecStart = "${fcitx5Package}/bin/fcitx5";
      Install.WantedBy = [ "graphical-session.target" ];
    };

    i18n.inputMethod.enabled = null;
  };
}
