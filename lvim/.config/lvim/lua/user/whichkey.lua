-- default makes quitting the editor too easy
lvim.builtin.which_key.mappings["q"] = nil
lvim.builtin.which_key.mappings["w"] = nil
-- don't need the close buffer default mapping
lvim.builtin.which_key.mappings["c"] = nil

-- re-assign lvim defaults
local function reassign_which_key(from, to)
  local mapping = lvim.builtin.which_key.mappings[from]
  lvim.builtin.which_key.mappings[to] = mapping
  lvim.builtin.which_key.mappings[from] = nil
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
-- TODO: move these to their own files

-- Telescope
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope find_files<CR>", "Grep" }
lvim.builtin.which_key.mappings["g"] = { "<cmd>Telescope live_grep<CR>", "Grep" }
lvim.builtin.which_key.mappings["*"] = { "<cmd>Telescope grep_string<CR>", "Grep" }
lvim.builtin.which_key.mappings["sP"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- mappings for my plugin
-- TODO: consider moving these to their respective plugin files

-- SymbolsOutline
lvim.builtin.which_key.mappings["o"] = { ":SymbolsOutline<CR>", "Outline" }

-- Trouble
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<CR>", "References" },
  f = { "<cmd>Trouble lsp_definitions<CR>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<CR>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<CR>", "QuickFix" },
  l = { "<cmd>Trouble loclist<CR>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<CR>", "Diagnostics" },
}

-- git-conflict
lvim.builtin.which_key.mappings["c"] = {
  name = "git-conflict",
  o = { "<Plug>(git-conflict-ours)", "Ours" },
  t = { "<Plug>(git-conflict-theirs)", "Theirs" },
  b = { "<Plug>(git-conflict-both)", "Both" },
  n = { "<Plug>(git-conflict-none)", "None", },
  j = { "<Plug>(git-conflict-next-conflict)", "Next" },
  k = { "<Plug>(git-conflict-prev-conflict)", "Prev" },
}
