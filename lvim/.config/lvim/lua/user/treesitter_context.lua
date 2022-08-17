local M = {}

M.config = function()
  local status_ok, treesitter_context = pcall(require, "treesitter-context")
  if not status_ok then
    vim.notify("treesitter-context not found", vim.log.levels.ERROR)
    return
  end

  treesitter_context.setup {
    -- max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    -- trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
      default = {
        "class",
        "function",
        "method",
        "for",
        "while",
        "if",
        -- 'switch',
        -- 'case',
      },
      rust = {
        "match",
        "impl_item",
      },
    },
    -- zindex = 20, -- The Z-index of the context window
    mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
    separator = "─", -- Separator between context and content. Should be a single character string, like '-'.
  }
end

return M
