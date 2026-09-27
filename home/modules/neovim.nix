{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = false;
    extraPackages = with pkgs; [
      fd
      ripgrep
      wl-clipboard
      gopls
      jdt-language-server
      nixd
      lua-language-server
      phpactor
      pyright
      rust-analyzer
      stylua
      taplo
      typescript
      typescript-language-server
      vscode-langservers-extracted
    ];
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      telescope-nvim
      plenary-nvim
      (nvim-treesitter.withPlugins (
        p: with p; [
          bash
          fish
          json
          lua
          markdown
          markdown_inline
          nix
          toml
          vim
          vimdoc
          yaml
          python
          go
          rust
          php
          java
          javascript
          typescript
          tsx
          html
          css
        ]
      ))
    ];
    initLua =
      builtins.readFile ../../config/nvim/options.lua
      + builtins.readFile ../../config/nvim/keymaps.lua
      + builtins.readFile ../../config/nvim/autocmds.lua
      + builtins.readFile ../../config/nvim/plugins.lua;
  };
}
