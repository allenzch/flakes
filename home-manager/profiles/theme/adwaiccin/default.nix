{ pkgs, inputs, ... }: {
  theme = {
    light = {
      iconTheme = "Papirus-Dark";
      gtkTheme = "adw-gtk3";
      cursorTheme = "capitaine-cursors";
      cursorSize = "36";
      kittyTheme = "${inputs.tinted-terminal}/themes/kitty/base16-catppuccin-latte.conf";
      vimTheme = "catppuccin-latte";
    };

    dark = {
      iconTheme = "Papirus-Dark";
      gtkTheme = "adw-gtk3";
      cursorTheme = "capitaine-cursors";
      cursorSize = "36";
      kittyTheme = "${inputs.tinted-terminal}/themes/kitty/base16-catppuccin-mocha.conf";
      vimTheme = "catppuccin-mocha";
    };
  };

  home.packages = with pkgs; [
    adw-gtk3
    capitaine-cursors
    papirus-icon-theme
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    catppuccin-nvim
  ];
}
