local M = {}

M.config = function()
  local status_ok, rust_tools = pcall(require, "rust-tools")
  if not status_ok then
    vim.notify("rust-tools not found", vim.log.levels.ERROR)
    return
  end

  local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
  local codelldb_adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = mason_path .. "bin/codelldb",
      args = { "--port", "${port}" },
    },
  }

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
      on_initialized = function()
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
          pattern = { "*.rs" },
          callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
          end,
        })
      end,
    },
    dap = {
      adapter = codelldb_adapter,
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
  }

  lvim.builtin.dap.on_config_done = function(dap)
    dap.adapters.codelldb = codelldb_adapter
    dap.configurations.rust = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
  end

  rust_tools.setup(opts)
end

return M
