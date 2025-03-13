{ pkgs, config, lib, ... }:
with lib; let
  theme = config.custom.misc.theme;
in {
  programs.neovim = {
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
      :colorscheme ${theme.inUse.vimTheme}
      :source ${./nvim.lua}
    '';
  };

  home.file.".config/nvim/after/ftplugin/python.vim".text = ''
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
  '';
}
