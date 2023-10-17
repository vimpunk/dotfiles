pcall(function()
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
        next = "<M-j>",
        prev = "<M-k>",
        dismiss = "<M-Esc>",
      },
    },
    panel = { enabled = false },
  })
end)
