{ config, lib, ... }:
with lib; {
  options.custom.portals = {
    shell = mkOption {
      default = {
        package = "fish";
        command = "fish -l";
      };
    };
    terminal = mkOption {
      default = "kitty";
    };
    launcher = mkOption {
      default = "fuzzel";
    };
    browser = mkOption {
      default = "firefox";
    };
  };
}