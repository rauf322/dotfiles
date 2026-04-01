vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    if not ev.data.active then
      vim.cmd.packadd(name)
    end

    if name == "nvim-treesitter" then
      vim.cmd("TSUpdate")
    elseif name == "telescope-fzf-native.nvim" then
      local dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
      vim.fn.system({ "make", "-C", dir })
    elseif name == "LuaSnip" then
      local dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/LuaSnip"
      vim.fn.system({ "make", "install_jsregexp", "-C", dir })
    elseif name == "markdown-preview.nvim" then
      vim.fn["mkdp#util#install"]()
    elseif name == "leetcode.nvim" then
      vim.cmd("TSUpdate html")
    end
  end,
})

vim.pack.add({
  -- Colorscheme (must be first for priority)
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  "https://github.com/vague-theme/vague.nvim",

  -- Core dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/echasnovski/mini.icons",

  -- LSP
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/nvimdev/lspsaga.nvim",
  "https://github.com/Fildo7525/pretty_hover",
  "https://github.com/antosha417/nvim-lsp-file-operations",

  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/windwp/nvim-ts-autotag",

  -- Completion
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
  "https://github.com/saghen/blink.compat",
  "https://github.com/moyiz/blink-emoji.nvim",
  "https://github.com/ray-x/cmp-sql",
  "https://github.com/supermaven-inc/supermaven-nvim",

  -- Snippets
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },
  "https://github.com/rafamadriz/friendly-snippets",

  -- Telescope
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",

  -- File explorer
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },

  -- UI
  "https://github.com/nvimdev/dashboard-nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/noice.nvim",
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/Nvchad/nvim-colorizer.lua",

  -- Formatting & linting
  "https://github.com/stevearc/conform.nvim",

  -- Git
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",

  -- Editing
  "https://github.com/echasnovski/mini.pairs",
  "https://github.com/tpope/vim-surround",
  "https://github.com/folke/flash.nvim",
  "https://github.com/Aasim-A/scrollEOF.nvim",

  -- Navigation
  "https://github.com/christoomey/vim-tmux-navigator",

  -- Diagnostics
  "https://github.com/folke/trouble.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/dmmulroy/tsc.nvim",

  -- Database
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/kristijanhusak/vim-dadbod-completion",

  -- Markdown
  "https://github.com/epwalsh/obsidian.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/iamcco/markdown-preview.nvim",

  -- Misc
  "https://github.com/kawre/leetcode.nvim",
  "https://github.com/theprimeagen/vim-be-good",
  "https://github.com/laytan/cloak.nvim",
  "https://github.com/vuki656/package-info.nvim",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/NickvanDyke/opencode.nvim",
})

-- Configure plugins (order matters for dependencies)
require("bitrift.plugins.colors")
require("bitrift.plugins.treesitter")
require("bitrift.plugins.mason")
require("bitrift.plugins.linting.formatingLinting")
require("bitrift.plugins.telescope")
require("bitrift.plugins.blink-cmp")
require("bitrift.plugins.neotree")
require("bitrift.plugins.dashboard")
require("bitrift.plugins.snacks")
require("bitrift.plugins.noice")
require("bitrift.plugins.lualine")
require("bitrift.plugins.lspsaga")
require("bitrift.plugins.which-key")
require("bitrift.plugins.snippet")
require("bitrift.plugins.github")
require("bitrift.plugins.diffview")
require("bitrift.plugins.opencode")
require("bitrift.plugins.plugins")
require("bitrift.plugins.bqf")
