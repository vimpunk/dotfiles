lvim.plugins = {
  -- core
  { "kevinhwang91/nvim-bqf" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "nacro90/numb.nvim" },
  {
    -- reopen files at last edit location
    "https://github.com/ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup()
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "christoomey/vim-tmux-navigator" }, -- seamless navigation between vim and tmux
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  -- NOTE: doesn't work on private registry urls
  -- TODO: test
  -- TODO: need to configure as <leader>gh classes with live_grep
  { "ruanyl/vim-gh-line" },
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      require "user.plugins.auto-dark-mode"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    config = function()
      require "user.plugins.harpoon"
    end
  },

  -- TODO: test
  { "https://github.com/HiPhish/nvim-ts-rainbow2" },

  -- copilot
  {
    "https://github.com/zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  },

  -- LSP
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    -- keep function signature in scope
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require "user.plugins.treesitter_context"
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup()
    end,
    event = { "BufRead", "BufNew" },
  },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust", "rs" },
  },
  {
    "saecki/crates.nvim",
    -- event = { "BufRead Cargo.toml" },
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
    end,
  },
  {
    "https://github.com/j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  },
  "mfussenegger/nvim-dap-python",
  "olexsmir/gopher.nvim",
  "leoluz/nvim-dap-go",
  -- TODO: seems to make lvim hang on :w. investigate
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require "user.plugins.symbols_outline"
    end
  },

  -- writing
  "vimwiki/vimwiki",
  {
    "folke/zen-mode.nvim",
    requires = { { "folke/twilight.nvim" } },
    config = function()
      require "user.plugins.zen-mode"
    end
  }
}

-- This has to be called separately for some reason.
require "user.plugins.lightspeed"
