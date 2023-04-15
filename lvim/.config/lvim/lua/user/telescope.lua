local function setup_pickers()
  -- Override default find_files picker to not show .git/ files but otherwise
  -- show all files, including hidden ones (e.g. .gitignore, .gitmodule, etc are all useful).
  lvim.builtin.telescope.pickers.find_files = {
    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
    find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
  }
  lvim.builtin.telescope.pickers.live_grep = {
    only_sort_text = false,
  }
  lvim.builtin.telescope.pickers.grep_string = {
    only_sort_text = false,
  }
end

local function setup_mappings()
  local status_ok, actions = pcall(require, "telescope.actions")
  if not status_ok then
    vim.notify("telescope.actions not found", vim.log.levels.ERROR)
    return
  end
  lvim.builtin.telescope.defaults.mappings = {
    -- for insert mode
    i = {
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-h>"] = actions.cycle_history_prev,
      -- TODO: remap this if needed, but C-n is needed for selecting entries
      -- ["<C-n>"] = actions.cycle_history_next,
      ["<C-u>"] = false, -- clear input line rather than scroll preview
    },
    -- for normal mode
    n = {
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
    },
  }

  -- lvim.builtin.telescope.defaults.pickers.find_files["theme"] = "dropdown"
  -- don't show shortened paths (the lvim default shortes to 5 chars)
  lvim.builtin.telescope.defaults.path_display = { shorten = nil }
end

setup_pickers()
setup_mappings()
