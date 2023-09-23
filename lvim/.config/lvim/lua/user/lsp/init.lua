require "user.lsp.langs.rust"
require "user.lsp.langs.go"
require "user.lsp.langs.solidity"
require "user.lsp.langs.clangd"

lvim.lsp.diagnostics.virtual_text = true
lvim.builtin.dap.active = true

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8", filetypes = { "python" } },
  {
    exe = "shellcheck",
  },
}
