{ config, lib, pkgs, ... }:
let
  inherit (config.theme) light dark;
  themeStatePath = "${config.home.homeDirectory}/${config.theme.themesDir}/nvim/state";
  vimThemeCfg = pkgs.writeText "vimThemeCfg.lua" ''
    local flag = vim.fn.readfile("${themeStatePath}")[1]
    vim.cmd.colorscheme(flag == "light" and "${light.vimTheme}" or "${dark.vimTheme}")
    vim.uv.new_fs_event():start("${themeStatePath}", {}, function()
      vim.schedule(function()
        local flag = vim.fn.readfile("${themeStatePath}")[1]
        vim.cmd.colorscheme(flag == "light" and "${light.vimTheme}" or "${dark.vimTheme}")
      end)
    end)
  '';
in
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
      fortls
      nixpkgs-fmt
      pyright
      rust-analyzer
    ];

    extraConfig = ''
      :luafile ${./nvim.lua}
      :luafile ${vimThemeCfg}
    '';
  };

  services.darkman =
    let
      mkScript =
        mode:
        pkgs.writeShellApplication {
          name = "darkman-switch-nvim-${mode}";
          text = ''
            echo ${mode} > ${themeStatePath}
          '';
        };
    in
    {
      lightModeScripts.neovim = "${lib.getExe (mkScript "light")}";
      darkModeScripts.neovim = "${lib.getExe (mkScript "dark")}";
    };
}
