{ pkgs, lib, ... }:
let
  inherit (lib) singleton;
  fcitx5Package = pkgs.qt6Packages.fcitx5-with-addons.override {
    addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-pinyin-zhwiki
      fcitx5-mozc-ut
    ];
    withConfigtool = true;
  };
in
{
  config = {
    home.packages = singleton fcitx5Package;

    persistence.directories = singleton  ".config/fcitx5";
  };
}
