{ pkgs, config, lib, ... }:
with lib; let
  theme = config.custom.misc.theme;
in {
  programs.neovim = mkMerge [{
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      catppuccin-nvim
      luasnip
      which-key-nvim
      leap-nvim
      nvim-autopairs
      nvim-treesitter
      nvim-tree-lua
      lualine-nvim
      lualine-lsp-progress
      bufferline-nvim
      telescope-nvim
      transparent-nvim
      csvview-nvim
    ];

    extraPackages = with pkgs; [
      wl-clipboard
      clang-tools
      nixd
      pyright
      fortls
      nixpkgs-fmt
    ];

    extraConfig = ''
      :source ${./nvim.lua}
    '';
  }
  (mkIf theme.enable {
    extraConfig = ''
      :colorscheme ${theme.inUse.vimTheme}
    '';
  })];

  home.file.".config/nvim/after/ftplugin/python.vim".text = ''
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
  '';
}
