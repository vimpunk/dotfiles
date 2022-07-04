local M = {}

M.config = function()
  lvim.plugins = {
    -- core enhancements
    { "kevinhwang91/nvim-bqf" },
    { "tpope/vim-surround" },
    { "tpope/vim-repeat" },
    { "Yggdroot/indentLine" },
    { "nacro90/numb.nvim" },
    {
      "https://github.com/ethanholz/nvim-lastplace",
      config = function()
        require "nvim-lastplace".setup()
      end
    }, -- reopen files at last edit location
    {
      "folke/trouble.nvim",
      cmd = "TroubleToggle",
    },
    { "christoomey/vim-tmux-navigator" }, -- seamless navigation between vim and tmux
    -- debugging
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup()
      end,
      ft = { "python", "rust", "go", "lua" },
      event = "BufReadPost",
      requires = { "mfussenegger/nvim-dap" },
    },
    -- language specific
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require "lsp_signature".setup()
      end,
      event = { "BufRead", "BufNew" },
    },
    {
      "simrat39/rust-tools.nvim",
      config = function()
        require "user.rust_tools".config()
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
    -- writing
    { "https://github.com/junegunn/goyo.vim" },
    { "https://github.com/junegunn/limelight.vim" },
    { "vimwiki/vimwiki" },
    -- colors
    { "folke/tokyonight.nvim" },
  }
end

return M
