{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.custom.layers.desktopBase;
in {
  options.custom.layers.desktopBase = {
    enable = mkEnableOption "basic desktop environment";
  };
  config = mkIf cfg.enable {
    custom.services = {
      sway = {
        enable = true;
      };
    };
    custom = {
      programs = {
        fish.enable = true;
        yazi.enable = true;
        htop.enable = true;
        neovim.enable = true;
      };
      i18n.fcitx5 = {
        enable = true;
        plasma6Support = true;
        withConfigtool = true;
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
        ];
      };
    };
    home.packages = with pkgs; [
      pavucontrol
    ];
    envPersist.directories = [
      "main"
    ];
  };
}
