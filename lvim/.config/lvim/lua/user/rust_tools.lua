local M = {}

M.config = function()
  local status_ok, rust_tools = pcall(require, "rust-tools")
  if not status_ok then
    vim.notify("rust-tools not found", vim.log.levels.ERROR)
    return
  end

  vim.cmd("autocmd! FileType rust setlocal nowrap")

  local opts = {
    tools = {
      reload_workspace_from_cargo_toml = true,
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
      -- cmd_env = requested_server._default_options.cmd_env,
      on_attach = require("lvim.lsp").common_on_attach,
      on_init = require("lvim.lsp").common_on_init,
      settings = {
        ["rust-analyzer"] = {
          completion = {
            privateEditable = {
              enable = true
            }
          },
          cargo = {
            features = "all"
          },
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
  }

  local path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/") or ""
  local codelldb_path = path .. "adapter/codelldb"
  local liblldb_path = path .. "lldb/lib/liblldb.so"
  if vim.fn.has "mac" == 1 then
    liblldb_path = path .. "lldb/lib/liblldb.dylib"
  end

  if vim.fn.filereadable(codelldb_path) and vim.fn.filereadable(liblldb_path) then
    opts.dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    }
  else
    local msg = "Either codelldb or liblldb is not readable."
      .. "\n codelldb: "
      .. codelldb_path
      .. "\n liblldb: "
      .. liblldb_path
    vim.notify(msg, vim.log.levels.ERROR)
  end

  rust_tools.setup(opts)
end

return M
