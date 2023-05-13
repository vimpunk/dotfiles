-- Guides:
-- https://github.com/LunarVim/starter.lvim/blob/rust-ide/config.lua
-- https://www.youtube.com/watch?v=kzLR8M1C4Hg

-- rust-analyzer is configured by rust-tools, disable LunarVim's rust-analyzer config
-- https://github.com/LunarVim/LunarVim/issues/2163
-- https://www.lunarvim.org/languages/rust.html#debugger
-- https://github.com/abzcoding/lvim/blob/main/lua/user/rust_tools.lua
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
local codelldb_adapter = {
  type = "server",
  port = "${port}",
  executable = {
    command = mason_path .. "bin/codelldb",
    args = { "--port", "${port}" },
  },
}

pcall(function()
  require("rust-tools").setup({
    tools = {
      reload_workspace_from_cargo_toml = true,
      autoSetHints = true,
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
  })
end)

-- TODO: consider moving all Rust LSP related plugin setup here

-- pcall(function()
--   require("fidget").setup()
-- end)

-- pcall(function()
--   require("crates").setup({
--     null_ls = {
--       enabled = true,
--       name = "crates.nvim",
--     },
--   })
-- end)

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
