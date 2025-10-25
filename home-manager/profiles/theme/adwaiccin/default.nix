{ pkgs, inputs, ... }: {
  custom.misc.theme = {
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
      base24Theme = {
        base00 = "eff1f5";
        base01 = "e6e9ef";
        base02 = "ccd0da";
        base03 = "bcc0cc";
        base04 = "acb0be";
        base05 = "4c4f69";
        base06 = "dc8a78";
        base07 = "7287fd";
        base08 = "d20f39";
        base09 = "fe640b";
        base0A = "df8e1d";
        base0B = "40a02b";
        base0C = "179299";
        base0D = "1e66f5";
        base0E = "8839ef";
        base0F = "dd7878";
        base10 = "e6e9ef";
        base11 = "dce0e8";
        base12 = "e64553";
        base13 = "dc8a78";
        base14 = "40a02b";
        base15 = "04a5e5";
        base16 = "209fb5";
        base17 = "ea76cb";
      };
      wallpaper = "${inputs.wallpapers}/wallhaven-6d312w.jpg";
      cursorTheme = {
        name = "capitaine-cursors-white";
        package = pkgs.capitaine-cursors;
        size = 36;
      };
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
      base24Theme = {
        base00 = "303446";
        base01 = "292c3c";
        base02 = "414559";
        base03 = "51576d";
        base04 = "626880";
        base05 = "c6d0f5";
        base06 = "f2d5cf";
        base07 = "babbf1";
        base08 = "e78284";
        base09 = "ef9f76";
        base0A = "e5c890";
        base0B = "a6d189";
        base0C = "81c8be";
        base0D = "8caaee";
        base0E = "ca9ee6";
        base0F = "eebebe";
        base10 = "292c3c";
        base11 = "232634";
        base12 = "ea999c";
        base13 = "f2d5cf";
        base14 = "a6d189";
        base15 = "99d1db";
        base16 = "85c1dc";
        base17 = "f4b8e4";
      };
      wallpaper = "${inputs.wallpapers}/wallhaven-d6jzvg.jpg";
      cursorTheme = {
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
        size = 36;
      };
      vimTheme = "catppuccin-frappe";
    };
  };
}
