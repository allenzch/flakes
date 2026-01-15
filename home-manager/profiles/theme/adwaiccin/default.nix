{ pkgs, inputs, ... }: {
  misc.theme = {
    enable = true;

    light = {
      iconTheme = {
        name = "Papirus-Light";
        package = pkgs.papirus-icon-theme;
      };
      gtkTheme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      cursorTheme = {
        name = "capitaine-cursors-white";
        package = pkgs.capitaine-cursors;
        size = 36;
      };
      kittyTheme = "${inputs.tinted-terminal}/themes/kitty/base16-catppuccin-latte.conf";
      vimTheme = "catppuccin-latte";
    };

    dark = {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtkTheme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      cursorTheme = {
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
        size = 36;
      };
      kittyTheme = "${inputs.tinted-terminal}/themes/kitty/base16-catppuccin-mocha.conf";
      vimTheme = "catppuccin-mocha";
    };
  };
}
