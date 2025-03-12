{ config, lib, ... }:
with lib;
let
  cfg = config.custom.misc.fontconfig;
  localeSpecificOverridesOpts = {
    options = {
      sourceFont = mkOption { type = types.str; };
      targetFont = mkOption { type = types.str; };
    };
  };
  genDefault = fonts: name:
    optionalString (fonts != [ ]) ''
      <match target="pattern">
        <test name="family">
          <string>${name}</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          ${concatStringsSep "\n" (map (font: "<string>${font}</string>") fonts)}
        </edit>
      </match>
    '';
  genLocaleSpecificOverrides = locale: sourceFont: targetFont: ''
    <match target="pattern">
      <test name="lang" compare="contains">
        <string>${locale}</string>
      </test>
      <test name="family" compare="contains">
        <string>${sourceFont}</string>
      </test>
      <edit name="family" mode="prepend" binding="strong">
        <string>${targetFont}</string>
      </edit>
    </match>
  '';
in
{
  options.custom.misc.fontconfig = {
    enable = mkEnableOption "fontconfig configuration";
    packages = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = "font packages";
    };
    defaultFonts = {
      monospace = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Per-user default monospace font(s). Multiple fonts may be listed in
          case multiple languages must be supported.
        '';
      };
      sansSerif = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Per-user default sans serif font(s). Multiple fonts may be listed
          in case multiple languages must be supported.
        '';
      };
      serif = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Per-user default serif font(s). Multiple fonts may be listed in
          case multiple languages must be supported.
        '';
      };
      emoji = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Per-user default emoji font(s). Multiple fonts may be listed in
          case a font does not support all emoji.

          Note that fontconfig matches color emoji fonts preferentially,
          so if you want to use a black and white font while having
          a color font installed (eg. Noto Color Emoji installed alongside
          Noto Emoji), fontconfig will still choose the color font even
          when it is later in the list.
        '';
      };
    };
    localeSpecificOverrides = mkOption {
      type = with types; attrsOf (listOf (submodule localeSpecificOverridesOpts));
      default = { };
      description = ''
        Per-user locale-specific font overrides.
      '';
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        home.packages = cfg.packages;

        xdg.configFile."fontconfig/fonts.conf".text =
          let
            overrides = flatten
              (mapAttrsToList
                (locale: overrides: (map (x: x // { inherit locale; }) overrides))
                cfg.localeSpecificOverrides
              );
          in
          ''
            <?xml version="1.0"?>
            <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
            <fontconfig>
              ${genDefault (singleton "sans-serif") "system-ui"}
              ${genDefault cfg.defaultFonts.sansSerif "sans-serif"}
              ${genDefault cfg.defaultFonts.serif "serif"}
              ${genDefault cfg.defaultFonts.monospace "monospace"}
              ${genDefault cfg.defaultFonts.emoji "emoji"}
              ${concatStringsSep "\n" (map (item: genLocaleSpecificOverrides item.locale item.sourceFont item.targetFont) overrides)}
            </fontconfig>
          '';
      }
    ]
  );
}
