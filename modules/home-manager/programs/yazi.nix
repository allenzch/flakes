{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.custom.programs.yazi;
in
{
  options.custom.programs.yazi = {
    enable = mkEnableOption "yazi";
  };
  config.programs.yazi = mkIf cfg.enable {
    enable = true;
    settings = {
      manager = {
        ratio = [ 1 4 3 ];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };
      open.prepend_rules = [
        { mime = "text/texmacs"; use = [ "open" "edit" ]; }
      ];
    };
  };
}
