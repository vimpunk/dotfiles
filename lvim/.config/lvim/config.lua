--------------------------------------------------------------------------------
-- LunarVim
--------------------------------------------------------------------------------
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

--------------------------------------------------------------------------------
-- general
--------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.scrolloff = 5
vim.opt.lazyredraw = true -- faster scrolling

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath "cache" .. "/undo"

vim.cmd [[set clipboard-=unnamedplus]]

lvim.autocommands._formatoptions = {}
vim.opt.formatoptions = {
    ["1"] = true,
    ["2"] = true, -- use indent from 2nd line of a paragraph
    q = true, -- continue comments with gq"
    c = true, -- auto-wrap comments using textwidth
    r = true, -- continue comments when pressing Enter
    n = true, -- recognize numbered lists
    t = true, -- autowrap lines using text width value
    j = true, -- remove a comment leader when joining lines.
    o = true, -- continue comments when inserting on new line
    -- Only break if the line was not longer than 'textwidth' when the insert
    -- started and only at a white character that has been entered during the
    -- current insert command.
    l = true,
    v = true,
}

--------------------------------------------------------------------------------
-- keymappings [view all the defaults by pressing <leader>Lk]
--------------------------------------------------------------------------------
lvim.leader = "space"

-- unmap lvim defaults
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["<S-h>"] = false
lvim.keys.normal_mode["kk"] = false
lvim.keys.normal_mode["kj"] = false

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["[b"] = ":bprev<CR>"
lvim.keys.normal_mode["]b"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<S-h>5k"
lvim.keys.normal_mode["<S-l>"] = "<S-l>5j"

-- move lines up and down
vim.cmd [[nnoremap <silent> <C-k> :move-2<CR>]]
vim.cmd [[xnoremap <silent> <C-k> :move-2<CR>gv]]
vim.cmd [[nnoremap <silent> <C-j> :move+<CR>]]
vim.cmd [[xnoremap <silent> <C-j> :move'>+<CR>gv]]

-- Make n and N always go in the same direction, no matter what search
-- direction you started off with, and always center the current match on the
-- screen.
vim.cmd [[nnoremap <expr> n 'Nn'[v:searchforward] . 'zz']]
vim.cmd [[nnoremap <expr> N 'nN'[v:searchforward] . 'zz']]

lvim.keys.normal_mode["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>"


-- FIXME:
-- vim.api.nvim_set_keymap('n', '<S-h>', '<S-h>5k', { noremap = true, silent = true })

--------------------------------------------------------------------------------
-- Telescope
--------------------------------------------------------------------------------
-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- We use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
lvim.builtin.telescope.defaults.pickers.find_files["theme"] = "dropdown"

--------------------------------------------------------------------------------
-- which_key
--------------------------------------------------------------------------------
-- default makes quitting the editor too easy
lvim.builtin.which_key.mappings["q"] = nil

-- re-assign lvim defaults
-- reassign git mapping from 'g' to capital 'G' to be harder to hit
local git = lvim.builtin.which_key.mappings["g"]
lvim.builtin.which_key.mappings["G"] = git

local packer = lvim.builtin.which_key.mappings["p"]
lvim.builtin.which_key.mappings["p"] = nil
lvim.builtin.which_key.mappings["P"] = packer

local clear_highlight = lvim.builtin.which_key.mappings["h"]
lvim.builtin.which_key.mappings["<space>"] = clear_highlight

-- new mappings
lvim.builtin.which_key.mappings["g"] = { "<cmd>Telescope live_grep<CR>", "Grep" }
lvim.builtin.which_key.mappings["sP"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["sp"] = { "<cmd>Telescope resume<CR>", "Prev" }

-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<CR>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<CR>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<CR>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<CR>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<CR>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "Diagnostics" },
-- }

--------------------------------------------------------------------------------
-- user config for default plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
--------------------------------------------------------------------------------
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true

--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.treesitter.highlight.enabled = true

--------------------------------------------------------------------------------
-- generic LSP settings
--------------------------------------------------------------------------------
-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { exe = "black", filetypes = { "python" } },
--   { exe = "isort", filetypes = { "python" } },
--   {
--     exe = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "flake8", filetypes = { "python" } },
--   {
--     exe = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--severity", "warning" },
--   },
--   {
--     exe = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

--------------------------------------------------------------------------------
-- additional plugins
--------------------------------------------------------------------------------
lvim.plugins = {
    -- core enhancements
    {"kevinhwang91/nvim-bqf"},
    {"tpope/vim-surround"},
    {"tpope/vim-repeat"},
    {"Yggdroot/indentLine"},
    {"nacro90/numb.nvim"},
    {"https://github.com/ethanholz/nvim-lastplace"},
    {"https://github.com/junegunn/goyo.vim"},
    -- language specific
    {"ray-x/lsp_signature.nvim"},
    {"simrat39/rust-tools.nvim"},
    -- colors
    {"folke/tokyonight.nvim"},
    -- {
    --   "folke/trouble.nvim",
    --   cmd = "TroubleToggle",
    -- },
}

require('neoscroll').setup({
   -- All these keys will be mapped to their corresponding default scrolling animation
   mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
               '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
   hide_cursor = true,          -- Hide cursor while scrolling
   stop_eof = true,             -- Stop at <EOF> when scrolling downwards
   use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
   respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
   cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
   easing_function = nil,        -- Default easing function
   pre_hook = nil,              -- Function to run before the scrolling animation starts
   post_hook = nil,              -- Function to run after the scrolling animation ends
})
require "lsp_signature".setup()
require "nvim-lastplace".setup()