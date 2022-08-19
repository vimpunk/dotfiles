local M = {}

M.config = function()
  local status_ok, rust_tools = pcall(require, "rust-tools")
  if not status_ok then
    vim.notify("rust-tools not found", vim.log.levels.ERROR)
    return
  end

  local lsp_installer_servers = require "nvim-lsp-installer.servers"
  local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"

  -- Use the vscode LLDB wrapper for a better debugging experience
  -- https://github.com/simrat39/rust-tools.nvim#a-better-debugging-experience
  local extensions_path = vim.fn.expand "~/" .. "/.vscode/extensions/vadimcn.vscode-lldb-1.6.7/"
  local codelldb_path = extensions_path .. "adapter/codelldb"
  local liblldb_path = extensions_path .. "lldb/lib/liblldb.dylib"

  vim.cmd("autocmd! FileType rust setlocal nowrap")

  rust_tools.setup({
    tools = {
      autoSetHints = true,
      hover_with_actions = true,
      hover_actions = {
        auto_focus = true,
      },
      runnables = {
        use_telescope = true,
      },
    },
    server = {
      cmd_env = requested_server._default_options.cmd_env,
      on_attach = require("lvim.lsp").common_on_attach,
      on_init = require("lvim.lsp").common_on_init,
      settings = {
        ["rust-analyzer"] = {
          -- completion = {
          --   postfix = {
          --     enable = false
          --   }
          -- },
          assist = {
            importEnforceGranularity = true,
            importPrefix = "crate"
          },
          checkOnSave = {
            command = "clippy"
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = "always",
              useParameterNames = true,
            },
            bindingModeHints = {
              enable = true,
            },
            closingBraceHints = {
              minLines = 1,
            },
          }
        },
      },
    },
    -- FIXME: this is not working with the vscode extension wrapper
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  })
end

return M
