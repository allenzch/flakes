{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.misc.theme;
  themeOpts = {
    options = {
      iconTheme = mkOption { };
      gtkTheme = mkOption { };
      base24Theme = mkOption { };
      cursorTheme = mkOption { };
    };
  };
in
{
  options.misc.theme = {
    enable = mkEnableOption "theme configuration";
    inUse = mkOption {
      type = types.submodule themeOpts;
      default = { };
      description = "theme configuration in use";
    };
    variant = mkOption {
      type = types.str;
      description = "theme variant in use";
    };
    light = mkOption {
      type = types.submodule themeOpts;
      default = { };
      description = "light theme configuration";
    };
    dark = mkOption {
      type = types.submodule themeOpts;
      default = { };
      description = "dark theme configuration";
    };
  };

  config = mkIf cfg.enable {
    misc.theme = {
      inUse = cfg.dark;
      variant = "dark";
    };

    home.packages = with pkgs; [
      (writeShellApplication {
        name = "toggle-theme";
        runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
        text = ''
          /home/${config.home.username}/current-home/specialisation/light-theme/activate
        '';
      })
    ];

    home.activation.setupTheme = lib.hm.dag.entryAfter [ "installPackages" ] ''
      if [[ -e $newGenPath/specialisation ]]; then
        test -h /home/${config.home.username}/current-home && unlink /home/${config.home.username}/current-home
        ln -s $newGenPath /home/${config.home.username}/current-home
      fi
    '';

    specialisation.light-theme.configuration = {
      misc.theme = {
        inUse = mkForce cfg.light;
        variant = mkForce "light";
      };

      home.packages = with pkgs; [
        (hiPrio (writeShellApplication {
          name = "toggle-theme";
          runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
          text = ''
            /home/${config.home.username}/current-home/activate
          '';
        }))
      ];
    };
  };
}
