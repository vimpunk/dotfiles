lvim.plugins = {
  -- core
  "kevinhwang91/nvim-bqf",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "nacro90/numb.nvim",
  {
    -- reopen files at last edit location
    "ethanholz/nvim-lastplace",
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
  { "HiPhish/nvim-ts-rainbow2" },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          -- set separately in nvim-cmp
          accept = false,
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-[>",
            prev = "<M-]>",
            dismiss = "<M-Esc>",
          },
        },
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
    dependencies = { { "nvim-lua/plenary.nvim" } },
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
    "j-hui/fidget.nvim",
    version = "legacy",
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

  -- git
  "tpope/vim-fugitive",
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = false
      })
    end
  },

  -- writing
  "vimwiki/vimwiki",
  {
    "folke/zen-mode.nvim",
    dependencies = { { "folke/twilight.nvim" } },
    config = function()
      require "user.plugins.zen-mode"
    end
  }
}

local cmp = require("cmp")
lvim.builtin.indentlines.active = false
-- https://github.com/zbirenbaum/copilot.lua/issues/91#issuecomment-1345190310
-- https://github.com/MunifTanjim/dotfiles/blob/6b5199346f7e96065d5e517e61e2d8768e10770d/private_dot_config/nvim/lua/plugins/cmp.lua#L48-L63
lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      elseif cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        -- elseif luasnip.expandable() then
        --   luasnip.expand()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),

    -- This has to be called separately for some reason.
    require "user.plugins.lightspeed"
