{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.custom.misc.theme;
  themeOpts = {
    options = {
      wallpaper = mkOption { };
      iconTheme = mkOption { };
      gtkTheme = mkOption { };
      base24Theme = mkOption { };
      cursorTheme = mkOption { };
      vimTheme = mkOption { };
      helixTheme = mkOption { };
    };
  };
in
{
  options.custom.misc.theme = {
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
    extraScript = mkOption {
      type = types.lines;
      default = "";
      description = "additional script to execute when switching theme specialisation";
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        custom.misc.theme = {
          inUse = cfg.dark;
          variant = "dark";
        };
        home.packages = with pkgs; [
          (writeShellApplication {
            name = "toggle-theme";
            runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
            text = ''
              "$(home-manager generations | head -1 | rg -o '/[^ ]*')"/specialisation/light-theme/activate
              ${cfg.extraScript}
            '';
          })
        ];

        home.activation.setupTheme = lib.hm.dag.entryAfter [ "installPackages" ] ''
          ${cfg.extraScript}
        '';

        specialisation.light-theme.configuration = {
          custom.misc.theme = {
            inUse = mkForce cfg.light;
            variant = mkForce "light";
          };

          home.packages = with pkgs; [
            (hiPrio (writeShellApplication {
              name = "toggle-theme";
              runtimeInputs = with pkgs; [ home-manager coreutils ripgrep ];
              text = ''
                "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate
                ${cfg.extraScript}
              '';
            }))
          ];
        };
      }
    ]
  );
}
