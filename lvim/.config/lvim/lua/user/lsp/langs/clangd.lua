-- local lsp_manager = require "lvim.lsp.manager"

-- local capabilities = vim.tbl_deep_extend(
--   'force',
--   require("lvim.lsp").common_capabilities() or vim.lsp.protocol.make_client_capabilities(),
--   {
--     textDocument = {
--       completion = {
--         editsNearCursor = true,
--       },
--     },
--     offsetEncoding = 'utf-16',
--   }
-- )
-- lsp_manager.setup("clangd", {
--   on_init = require("lvim.lsp").common_on_init,
--   capabilities = capabilities,
--   cmd = {
--     "clangd", "--offset-encoding=utf-16",
--   }
-- })

-- local notify = vim.notify
-- vim.notify = function(msg, ...)
--   if msg:match("warning: multiple different client offset_encodings") then
--     return
--   end

--   notify(msg, ...)
-- end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-8" }

require("lspconfig").clangd.setup({
  capabilities = capabilities,
  -- on_attach = function(client)
  --     client.resolved_capabilities.document_formatting = false
  -- end,
  -- cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy=0" }
})
