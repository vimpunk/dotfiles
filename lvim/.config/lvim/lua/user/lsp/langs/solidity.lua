vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solidity" })

local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"

-- https://old.reddit.com/r/neovim/comments/xskq9u/solidity_devs_what_does_your_setup_look_like/jdb51jy/
configs.solidity = {
  default_config = {
    cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
    filetypes = { "solidity" },
    root_dir = lspconfig.util.find_git_ancestor,
    single_file_support = true,
  },
}

lspconfig.solidity.setup({})

require("null-ls").builtins.formatting.prettier.with({
    extra_filetypes = { "solidity" },
})
