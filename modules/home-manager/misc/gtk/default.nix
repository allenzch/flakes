{ config, lib, ... }:
with lib;
let
  cfg = config.custom.misc.gtk;
  theme = config.custom.misc.theme;

  cfg2 = cfg.gtk2;
  cfg3 = cfg.gtk3;
  cfg4 = cfg.gtk4;

  toGtk3Ini = generators.toINI {
    mkKeyValue = key: value:
      let value' = if isBool value then boolToString value else toString value;
      in "${escape [ "=" ] key}=${value'}";
  };

  formatGtk2Option = n: v:
    let
      v' =
        if isBool v then
          boolToString value
        else if isString v then
          ''"${v}"''
        else
          toString v;
    in
    "${escape [ "=" ] n} = ${v'}";

  themeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = ''
          Package providing the theme. This package will be installed
          to your profile. If `null` then the theme
          is assumed to already be available in your profile.

          For the theme to apply to GTK 4, this option is mandatory.
        '';
      };
      name = mkOption {
        type = types.str;
        description = "The name of the theme within the package.";
      };
    };
  };

  iconThemeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = ''
          Package providing the icon theme. This package will be installed
          to your profile. If `null` then the theme
          is assumed to already be available in your profile.
        '';
      };
      name = mkOption {
        type = types.str;
        description = "The name of the icon theme within the package.";
      };
    };
  };

  cursorThemeType = types.submodule {
    options = {
      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = ''
          Package providing the cursor theme. This package will be installed
          to your profile. If `null` then the theme
          is assumed to already be available in your profile.
        '';
      };
      name = mkOption {
        type = types.str;
        description = "The name of the cursor theme within the package.";
      };
      size = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          The size of the cursor.
        '';
      };
    };
  };
in
{
  options.custom.misc.gtk = {
    enable = mkEnableOption "gtk configuration";
    font = mkOption {
      type = types.nullOr hm.types.fontType;
      default = null;
      description = ''
        The font to use in GTK+ 2/3 applications.
      '';
    };
    cursorTheme = mkOption {
      type = types.nullOr cursorThemeType;
      default = null;
      description = "The cursor theme to use.";
    };
    iconTheme = mkOption {
      type = types.nullOr iconThemeType;
      default = null;
      description = "The icon theme to use.";
    };
    theme = mkOption {
      type = types.nullOr themeType;
      default = null;
      description = "The GTK+2/3 theme to use.";
    };
    gtk2 = {
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to
          {file}`~/.gtkrc-2.0`.
        '';
      };
      configLocation = mkOption {
        type = types.path;
        default = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        description = ''
          The location to put the GTK configuration file.
        '';
      };
    };
    gtk3 = {
      bookmarks = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Bookmarks in the sidebar of the GTK file browser";
      };
      extraConfig = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        default = { };
        description = ''
          Extra configuration options to add to
          {file}`$XDG_CONFIG_HOME/gtk-3.0/settings.ini`.
        '';
      };
      extraCss = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to
          {file}`$XDG_CONFIG_HOME/gtk-3.0/gtk.css`.
        '';
      };
    };
    gtk4 = {
      extraConfig = mkOption {
        type = with types; attrsOf (either bool (either int str));
        default = { };
        description = ''
          Extra configuration options to add to
          {file}`$XDG_CONFIG_HOME/gtk-4.0/settings.ini`.
        '';
      };
      extraCss = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration lines to add verbatim to
          {file}`$XDG_CONFIG_HOME/gtk-4.0/gtk.css`.
        '';
      };
    };
  };

  config = mkIf cfg.enable (
    let
      gtkIni = optionalAttrs (cfg.font != null)
        {
          gtk-font-name =
            let
              fontSize =
                optionalString (cfg.font.size != null) " ${toString cfg.font.size}";
            in
            "${cfg.font.name}" + fontSize;
        } // optionalAttrs (cfg.theme != null) {
        gtk-theme-name = cfg.theme.name;
      } // optionalAttrs (cfg.iconTheme != null) {
        gtk-icon-theme-name = cfg.iconTheme.name;
      } // optionalAttrs (cfg.cursorTheme != null) {
        gtk-cursor-theme-name = cfg.cursorTheme.name;
      } // optionalAttrs (cfg.cursorTheme != null && cfg.cursorTheme.size != null) {
        gtk-cursor-theme-size = cfg.cursorTheme.size;
      };

      dconfIni = optionalAttrs (cfg.font != null)
        {
          font-name =
            let
              fontSize =
                optionalString (cfg.font.size != null) " ${toString cfg.font.size}";
            in
            "${cfg.font.name}" + fontSize;
        } // optionalAttrs (cfg.theme != null) {
        gtk-theme = cfg.theme.name;
      } // optionalAttrs (cfg.iconTheme != null) {
        icon-theme = cfg.iconTheme.name;
      } // optionalAttrs (cfg.cursorTheme != null) {
        cursor-theme = cfg.cursorTheme.name;
      } // optionalAttrs (cfg.cursorTheme != null && cfg.cursorTheme.size != null) {
        cursor-size = cfg.cursorTheme.size;
      };

      optionalPackage = opt:
        optional (opt != null && opt.package != null) opt.package;
    in
    mkMerge [
      {
        home.packages = concatMap optionalPackage [
          cfg.font
          cfg.theme
          cfg.iconTheme
          cfg.cursorTheme
        ];

        home.file.${cfg2.configLocation}.text =
          concatMapStrings (l: l + "\n") (mapAttrsToList formatGtk2Option gtkIni)
          + cfg2.extraConfig + "\n";

        home.sessionVariables.GTK2_RC_FILES = cfg2.configLocation;

        xdg.configFile."gtk-3.0/settings.ini".text = toGtk3Ini { Settings = gtkIni // cfg3.extraConfig; };

        xdg.configFile."gtk-3.0/gtk.css" = mkIf (cfg3.extraCss != "") { text = cfg3.extraCss; };

        xdg.configFile."gtk-3.0/bookmarks" = mkIf (cfg3.bookmarks != [ ]) {
          text = concatMapStrings (l: l + "\n") cfg3.bookmarks;
        };

        xdg.configFile."gtk-4.0/settings.ini".text = toGtk3Ini { Settings = gtkIni // cfg4.extraConfig; };

        xdg.configFile."gtk-4.0/gtk.css" = mkIf (cfg4.extraCss != "") { text = cfg4.extraCss; };

        dconf.settings."org/gnome/desktop/interface" = dconfIni;
      }
      (mkIf theme.enable {
        custom.misc.gtk = {
          iconTheme = theme.inUse.iconTheme;
          theme = theme.inUse.gtkTheme;
          cursorTheme = theme.inUse.cursorTheme;
        };

        dconf.settings."org/gnome/desktop/interface".color-scheme =
          if theme.variant == "dark" then "prefer-dark" else "prefer-light";
      })
    ]
  );
}
