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
      require "user.plugins.copilot"
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

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

lvim.builtin.indentlines.active = false

-- When there is a copilot suggestion, accept it with <CR>.
-- https://github.com/zbirenbaum/copilot.lua/issues/91#issuecomment-1345190310
local cmp = require("cmp")

-- If cmp suggestions are visible but none are selected (i.e. initial state),
-- accept copilot suggestion. Otherwise we have selected one of the cmp entries
-- with <Tab> and <CR> should accept that entry rather than copilot's
-- suggestion.
lvim.builtin.cmp.mapping["<CR>"] = cmp.mapping(function(fallback)
  local copilot_suggestion = require("copilot.suggestion")
  local copilot_visible = copilot_suggestion.is_visible()
  if cmp.visible() then
    -- If copilot is already visible, nvim-cmp does not jump to the first
    -- suggested entry, in which case we don't want to auto-accept that first
    -- entry until we explicitly go onto it with <Tab>. Otherwise no copilot
    -- suggestion, nvim-cmp auto jumps to the first entry in the selection menu
    -- and we can accept it as that's most likely what we want.
    local e = copilot_visible and cmp.get_active_entry() or cmp.get_selected_entry()
    if e then
      if cmp.confirm({ select = false }) then
        return
      end
    end
  end

  if copilot_visible then
    copilot_suggestion.accept()
  else
    fallback()
  end
end, {
  "i",
  "s",
})

-- When there is a cmp suggestion, accept it with <Tab>, or if there is a word, trigger completion.
-- https://github.com/MunifTanjim/dotfiles/blob/6b5199346f7e96065d5e517e61e2d8768e10770d/private_dot_config/nvim/lua/plugins/cmp.lua#L48-L63
-- maybe make it so that tab returns to copilot suggestion after going through all cmp suggestions?
lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
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
