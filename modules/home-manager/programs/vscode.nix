{ config, lib, pkgs, ... }:
with lib; let cfg = config.custom.programs.vscode;
in {
  options.custom.programs.vscode = {
    enable = mkEnableOption "vscode";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      userSettings = {
        editor = {
          tabSize = 2;
          wordWrap = "on";
        };
        workbench = {
          colorTheme = {
            "light" = "Catppuccin Latte";
            "dark" = "Catppuccin Macchiato";
          }.${config.custom.theme.variant};
          preferredLightColorTheme = "Catppuccin Latte";
          preferredDarkColorTheme = "Catppuccin Macchiato";
        };
        window.autoDetectColorScheme = "on";
      };
      extensions = with pkgs; [
        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.bbenoist.nix
      ];
    };
    home.activation.beforeCheckLinkTargets = {
      after = [];
      before = [ "checkLinkTargets" ];
      data = ''
        userDir=/home/${config.home.username}/.config/VSCodium/User
        rm -rf $userDir/settings.json
      '';
    };
    home.activation.afterWriteBoundary = {
      after = [ "writeBoundary" ];
      before = [];
      data = ''
        userDir=/home/${config.home.username}/.config/VSCodium/User
        rm -rf $userDir/settings.json
        mkdir -p $userDir
        cat \
          ${(pkgs.formats.json {}).generate "blabla"
            config.programs.vscode.userSettings} \
          > $userDir/settings.json
      '';
    };
  };
}