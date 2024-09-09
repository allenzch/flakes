{ pkgs, config, lib, ... }:
with lib; let
  cfg = config.custom.programs.neovim;
  theme = config.custom.misc.theme;
in {
  options.custom.programs.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # language server
      nil
      pyright
      rust-analyzer

      # formatter
      nixpkgs-fmt
    ];

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

      extraPackages = with pkgs; [ wl-clipboard ];

      extraConfig = ''
        :colorscheme ${theme.inUse.vimTheme}
        :source ${./nvim.lua}
      '';
    };
  };
}
