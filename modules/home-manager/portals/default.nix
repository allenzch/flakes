{ config, lib, ... }:
with lib; let cfg = config.custom.portals;
in {
  options.custom.portals = {
    windowManager = {
      enable = mkEnableOption "window manager";
      backend = mkOption {
        type = types.str;
        default = "sway";
      };
      command = mkOption {
        type = types.str;
        default = cfg.windowManager.backend;
      };
    };
    shell = {
      enable = mkEnableOption "shell";
      backend = mkOption {
        type = types.str;
        default = "fish";
      };
      command = mkOption {
        type = types.str;
        default = cfg.shell.backend;
      };
    };
    terminal = {
      enable = mkEnableOption "terminal";
      backend = mkOption {
        type = types.str;
        default = "kitty";
      };
      command = mkOption {
        type = types.str;
        default = cfg.terminal.backend;
      };
    };
    launcher = {
      enable = mkEnableOption "launcher";
      backend = mkOption {
        type = types.str;
        default = "fuzzel";
      };
      command = mkOption {
        type = types.str;
        default = cfg.launcher.backend;
      };
    };
    browser = {
      enable = mkEnableOption "browser";
      backend = mkOption {
        type = types.str;
        default = "firefox";
      };
      command = mkOption {
        type = types.str;
        default = cfg.browser.backend;
      };
    };
  };
  config.custom = {
    programs = {
      ${cfg.shell.backend} = mkIf cfg.shell.enable { enable = true; };
      ${cfg.terminal.backend} = mkIf cfg.terminal.enable { enable = true; };
      ${cfg.launcher.backend} = mkIf cfg.launcher.enable { enable = true; };
      ${cfg.browser.backend} = mkIf cfg.browser.enable { enable = true; };
    };
    services.${cfg.windowManager.backend} = mkIf cfg.windowManager.enable { enable = true; };
  };
}
