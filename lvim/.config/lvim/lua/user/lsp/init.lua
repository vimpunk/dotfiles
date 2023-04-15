require "user.lsp.langs.rust"
require "user.lsp.langs.go"
require "user.lsp.langs.solidity"

lvim.lsp.diagnostics.virtual_text = true
lvim.builtin.dap.active = true

lvim.keys.normal_mode["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>"

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8", filetypes = { "python" } },
  {
    exe = "shellcheck",
  },
}
