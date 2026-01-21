{ config, lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str submodule;
  cfg = config.theme;
  themeOpts = {
    options = {
      iconTheme = mkOption { };
      gtkTheme = mkOption { };
      cursorTheme = mkOption { };
      cursorSize = mkOption { };
      kittyTheme = mkOption { };
      vimTheme = mkOption { };
    };
  };
in
{
  options.theme = {
    themesDir = mkOption {
      type = str;
      default = ".config/themes";
    };
    light = mkOption {
      type = submodule themeOpts;
      default = { };
    };
    dark = mkOption {
      type = submodule themeOpts;
      default = { };
    };
  };
  
  config.persistence.directories = [ "${cfg.themesDir}" ];
}
