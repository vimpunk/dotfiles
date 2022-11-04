local M = {}

M.config = function()
  lvim.plugins = {
    -- core enhancements
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
    -- { "ruanyl/vim-gh-line" }, -- TODO: test. doesn't work on private registry urls
    {
      -- keep function signature in scope
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require("user.treesitter_context").config()
      end
    },
    -- LSP
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "simrat39/rust-tools.nvim",
      config = function()
        require("user.rust_tools").config()
      end,
      ft = { "rust", "rs" },
    },
    {
      "saecki/crates.nvim",
      -- event = { "BufRead Cargo.toml" },
      requires = { { 'nvim-lua/plenary.nvim' } },
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
    -- TODO: this freezes the editor on :w, enable back once blocking is fixed
    -- {
    --   "simrat39/symbols-outline.nvim",
    --   config = function()
    --     require("user.symbols_outline").config()
    --   end
    -- },
    -- writing
    { "https://github.com/junegunn/goyo.vim" },
    { "https://github.com/junegunn/limelight.vim" },
    { "vimwiki/vimwiki" },
  }
end

return M
