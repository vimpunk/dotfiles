--------------------------------------------------------------------------------
-- LunarVim
--------------------------------------------------------------------------------
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"

-- For some reason lunarvim's autoformatter completely messes up proto files.
-- Disable as a temporary workaround.
vim.cmd("autocmd! FileType proto lua lvim.format_on_save = false")
-- vim.cmd("autocmd! FileType toml lua lvim.format_on_save = false") # TODO: doesn't work for some reason

--------------------------------------------------------------------------------
-- general
--------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true -- don't break lines mid-word
vim.opt.breakindent = true
vim.opt.scrolloff = 5
vim.opt.lazyredraw = true -- faster scrolling
vim.cmd [[let &showbreak='↳ ']] -- pretty line break signaler
vim.opt.concealcursor = "" -- don't conceal on current line

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath "cache" .. "/undo"

vim.cmd [[set clipboard-=unnamedplus]]

-- https://github.com/LunarVim/LunarVim/issues/2878
pcall(vim.api.nvim_del_augroup_by_name, "_format_options")
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
lvim.keys.insert_mode["kk"] = false
lvim.keys.insert_mode["kj"] = false
lvim.keys.insert_mode["kJ"] = false
lvim.keys.insert_mode["KJ"] = false
lvim.keys.insert_mode["KJ"] = false
lvim.keys.insert_mode["<C-h>"] = false
lvim.keys.insert_mode["<C-j>"] = false
lvim.keys.insert_mode["<C-k>"] = false
lvim.keys.insert_mode["<C-l>"] = false
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["<S-h>"] = false

lvim.keys.insert_mode["jk"] = "<esc>"

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["[b"] = ":bprev<CR>"
lvim.keys.normal_mode["]b"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<S-h>5k"
lvim.keys.normal_mode["<S-l>"] = "<S-l>5j"

-- TODO: these currently don't work due to clashing with pane navigation bindings
-- -- move lines up and down
-- vim.cmd [[nnoremap <silent> <C-k> :move-2<CR>]]
-- vim.cmd [[xnoremap <silent> <C-k> :move-2<CR>gv]]
-- vim.cmd [[nnoremap <silent> <C-j> :move+<CR>]]
-- vim.cmd [[xnoremap <silent> <C-j> :move'>+<CR>gv]]

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
require "user.telescope".config()

--------------------------------------------------------------------------------
-- which_key
--------------------------------------------------------------------------------
-- default makes quitting the editor too easy
lvim.builtin.which_key.mappings["q"] = nil
lvim.builtin.which_key.mappings["w"] = nil

-- re-assign lvim defaults
local function reassign_which_key(from, to)
  local mapping = lvim.builtin.which_key.mappings[from]
  lvim.builtin.which_key.mappings[from] = nil
  lvim.builtin.which_key.mappings[to] = mapping
end

-- Reassign git mapping from 'g' to capital 'G' to be harder to hit. `g` will
-- be assigned to live grep.
reassign_which_key("g", "G")
-- same for packer
reassign_which_key("p", "P")
-- Colorscheme with preview overrides regular colorscheme command as it's more
-- useful. `sp` will be assigned to previous search.
reassign_which_key("sp", "sc")
-- <space><space> is more comfy since it's used a lot.
reassign_which_key("h", "<space>")

-- Changes an existing mapping to a completely new one. Old mapping is deleted,
-- so should be re-assigned first.
local function change_which_key(key, mapping)
  lvim.builtin.which_key.mappings[key] = nil
  lvim.builtin.which_key.mappings[key] = mapping
end

change_which_key("sp", { "<cmd>Telescope resume<CR>", "Prev" })

-- new mappings
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope find_files<CR>", "Grep" }
lvim.builtin.which_key.mappings["g"] = { "<cmd>Telescope live_grep<CR>", "Grep" }
lvim.builtin.which_key.mappings["sP"] = { "<cmd>Telescope projects<CR>", "Projects" }

lvim.builtin.which_key.mappings["j"] = { "<Plug>Lightspeed_s", "Lightjump" }
lvim.builtin.which_key.mappings["J"] = { "<Plug>Lightspeed_S", "Lightjump" }

lvim.builtin.which_key.mappings["o"] = { ":SymbolsOutline<CR>", "Outline" }

lvim.builtin.which_key.mappings["ds"] = {
  "<cmd>lua if vim.bo.filetype == 'rust' then vim.cmd[[RustDebuggables]] else require'dap'.continue() end<CR>",
  "Start",
}

lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<CR>", "References" },
  f = { "<cmd>Trouble lsp_definitions<CR>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<CR>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<CR>", "QuickFix" },
  l = { "<cmd>Trouble loclist<CR>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "Diagnostics" },
}

--------------------------------------------------------------------------------
-- user config for default plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
--------------------------------------------------------------------------------
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
-- This was remapped to `<C-\>` in a recent update.
lvim.builtin.terminal.open_mapping = "<C-t>"
-- Don't set cwd which causes issues when it re-roots within the same repository and
-- then searching in parent won't work. To manually set cwd, use
-- `:ProjectRoot`.
lvim.builtin.project.manual_mode = true
lvim.builtin.nvimtree.setup.view.side = "left"

-- if you don't want all the parsers change this to a table of the ones you
-- want
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
-- lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.treesitter.highlight.enabled = true

--------------------------------------------------------------------------------
-- generic LSP settings
--------------------------------------------------------------------------------
-- rust-analyzer is configured by rust-tools, disable LunarVim's
-- rust-analyzer config
-- https://github.com/LunarVim/LunarVim/issues/2163
-- https://www.lunarvim.org/languages/rust.html#debugger
-- https://github.com/abzcoding/lvim/blob/main/lua/user/rust_tools.lua
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer", "taplo" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_filetypes, { "toml" })
-- don't install taplo as it messes up Cargo.toml files by autoformatting and there is no way to turn it off afaik
lvim.lsp.installer.setup.automatic_installation = { exclude = { "taplo" } }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

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

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8", filetypes = { "python" } },
  {
    exe = "shellcheck",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    -- args = { "--severity", "warning" },
  },
  -- {
  --   exe = "codespell",
  --   ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
  --   -- filetypes = { "javascript", "python" },
  -- },
}


--------------------------------------------------------------------------------
-- additional plugins
--------------------------------------------------------------------------------
require "user.plugins".config()

--------------------------------------------------------------------------------
-- Debugger Adapter Protocol
--------------------------------------------------------------------------------

-- This needs to be enabled in order to run nvim-dap
lvim.builtin.dap.active = true
lvim.builtin.dap.on_config_done = function(dap)
  dap.adapters.lldb = {
    type = "executable",
    -- TODO: the only way this works is like this. rust-tools' dap integration is broken
    command = "/opt/homebrew/opt/llvm/bin/lldb-vscode",
    name = "lldb"
  }

  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      runInTerminal = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  -- This is needed if running the debugger outside of rust-tools.
  dap.configurations.rust = dap.configurations.cpp
end

--------------------------------------------------------------------------------
-- lightspeed --
--------------------------------------------------------------------------------
-- disable default lightspeed mappings
lvim.keys.normal_mode["s"] = "s"
lvim.keys.normal_mode["S"] = "S"
lvim.keys.visual_mode["s"] = "s"
lvim.keys.visual_mode["S"] = "S"

-- vim.cmd [[
--   nmap <space>j <Plug>Lightspeed_s
--   nmap <space>J <Plug>Lightspeed_S
-- ]]

--------------------------------------------------------------------------------
-- toggleterm --
--------------------------------------------------------------------------------
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

vim.cmd([[
let g:goyo_linenr = 1
]])

-- FIXME
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.rs", ".lua" },
--   command = ":SymbolsOutlineOpen",
--   group = vim.api.nvim_create_augroup("my_symbols_outline_au", { clear = true }),
-- })
