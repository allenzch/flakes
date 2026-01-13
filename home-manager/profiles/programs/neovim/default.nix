{ pkgs, ... }:
{
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
      transparent-nvim
      csvview-nvim
      base16-nvim
    ];

    extraPackages = with pkgs; [
      wl-clipboard
      clang-tools
      nixd
      pyright
      fortls
      nixpkgs-fmt
      rust-analyzer
    ];

    extraConfig = ''
      :source ${./nvim.lua}
    '';
  };
}
