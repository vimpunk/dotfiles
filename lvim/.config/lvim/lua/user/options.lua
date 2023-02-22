--------------------------------------------------------------------------------
-- core
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
-- lunarvim
--------------------------------------------------------------------------------
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
-- This was remapped to `<C-\>` in a recent update.
lvim.builtin.terminal.open_mapping = "<C-t>"
-- Don't set cwd which causes issues when it re-roots within the same repository and
-- then searching in parent won't work. To manually set cwd, use
-- `:ProjectRoot`.
-- TODO: just setting manual_mode should work but has not been working for a while,
-- so the plugin is disabled entirely
lvim.builtin.project.active = false
lvim.builtin.project.manual_mode = true
lvim.builtin.nvimtree.setup.view.side = "left"

-- lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.treesitter.highlight.enabled = true
