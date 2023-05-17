require "user.lsp.langs.rust"
require "user.lsp.langs.go"
require "user.lsp.langs.solidity"

lvim.lsp.diagnostics.virtual_text = true
lvim.builtin.dap.active = true

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { exe = "flake8", filetypes = { "python" } },
  {
    exe = "shellcheck",
  },
}

-- TODO: fix, for some reason it's not set
lvim.keys.normal_mode["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>"
