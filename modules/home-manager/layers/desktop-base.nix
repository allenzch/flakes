{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.custom.layers.desktopBase;
  portals = config.custom.portals;
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
        ${portals.terminal}.enable = true;
        ${portals.launcher}.enable = true;
        ${portals.browser}.enable = true;
        waybar.enable = true;
        fish.enable = true;
        yazi.enable = true;
        htop.enable = true;
        neovim.enable = true;
      };
      theme.enable = true;
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
      wl-clipboard
    ];
    envPersist.directories = [
      "main"
    ];
  };
}