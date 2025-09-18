{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # LazyVim
      lua-language-server
      stylua
      # Telescope
      ripgrep
      # lazygit
      lazygit
      wl-clipboard # for nvim clipboard support
      fd
      gcc
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraLuaConfig = let
      plugins = with pkgs.vimPlugins; [
        LazyVim
        bufferline-nvim
        cmp_luasnip
        conform-nvim
        dashboard-nvim
        flash-nvim
        friendly-snippets
        gitsigns-nvim
        lualine-nvim
        neo-tree-nvim
        neoconf-nvim
        neodev-nvim
        noice-nvim
        nui-nvim
        nvim-lint
        nvim-lspconfig
        nvim-notify
        nvim-spectre
        nvim-treesitter
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-web-devicons
        persistence-nvim
        plenary-nvim
        todo-comments-nvim
        tokyonight-nvim
        trouble-nvim
        vim-illuminate
        vim-startuptime
        which-key-nvim
        fzf-lua
        snacks-nvim
        {
          name = "lazydev.nvim";
          path = lazydev-nvim;
        }
        {
          name = "blink.cmp";
          path = blink-cmp;
        }
        {
          name = "LuaSnip";
          path = luasnip;
        }
        {
          name = "catppuccin";
          path = catppuccin-nvim;
        }
        {
          name = "mini.ai";
          path = mini-nvim;
        }
        {
          name = "mini.bufremove";
          path = mini-nvim;
        }
        {
          name = "mini.comment";
          path = mini-nvim;
        }
        {
          name = "mini.indentscope";
          path = mini-nvim;
        }
        {
          name = "mini.pairs";
          path = mini-nvim;
        }
        {
          name = "mini.surround";
          path = mini-nvim;
        }
        {
          name = "mini.icons";
          path = mini-icons;
        }
        {
          name = "grug-far.nvim";
          path = grug-far-nvim;
        }
      ];
      mkEntryFromDrv = drv:
        if lib.isDerivation drv
        then {
          name = "${lib.getName drv}";
          path = drv;
        }
        else drv;
      lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
    in ''
      require("lazy").setup({
        defaults = {
          lazy = true,
        },
        dev = {
          -- reuse files from pkgs.vimPlugins.*
          path = "${lazyPath}",
          patterns = { "." },
          -- fallback to download
          fallback = true,
        },
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- The following configs are needed for fixing lazyvim on nix
          -- disable mason.nvim, use programs.neovim.extraPackages
          { "mason-org/mason-lspconfig.nvim", enabled = false },
          { "mason-org/mason.nvim", enabled = false },
          -- import/override with your plugins
          { import = "lazyvim.plugins.extras.lang.go" },
          { import = "lazyvim.plugins.extras.lang.clangd" },
          { import = "lazyvim.plugins.extras.lang.rust" },
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.lang.python" },
          { import = "plugins" },
          -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
          { "nvim-treesitter/nvim-treesitter",
           opts = function(_, opts)
            opts.ensure_installed = {}
          end,
          },
        },
      })
    '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source = let
    parsers = pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths =
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
          with plugins; [
            c
            lua
          ]))
        .dependencies;
    };
  in "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
