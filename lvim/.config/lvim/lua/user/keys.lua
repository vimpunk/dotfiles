--------------------------------------------------------------------------------
-- keymappings [view all the defaults by pressing <leader>Lk]
--------------------------------------------------------------------------------
lvim.leader = "space"

-- unmap lvim defaults
lvim.keys.insert_mode["kk"] = false
lvim.keys.insert_mode["kj"] = false
lvim.keys.insert_mode["kJ"] = false
lvim.keys.insert_mode["KJ"] = false
lvim.keys.insert_mode["KJ"] = false
lvim.keys.insert_mode["<C-h>"] = false
lvim.keys.insert_mode["<C-j>"] = false
lvim.keys.insert_mode["<C-k>"] = false
lvim.keys.insert_mode["<C-l>"] = false
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["<S-h>"] = false

lvim.keys.insert_mode["jk"] = "<esc>"

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["[b"] = ":bprev<CR>"
lvim.keys.normal_mode["]b"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<S-h>5k"
lvim.keys.normal_mode["<S-l>"] = "<S-l>5j"

-- TODO: these currently don't work due to clashing with pane navigation bindings
-- -- move lines up and down
-- vim.cmd [[nnoremap <silent> <C-k> :move-2<CR>]]
-- vim.cmd [[xnoremap <silent> <C-k> :move-2<CR>gv]]
-- vim.cmd [[nnoremap <silent> <C-j> :move+<CR>]]
-- vim.cmd [[xnoremap <silent> <C-j> :move'>+<CR>gv]]

-- Make n and N always go in the same direction, no matter what search
-- direction you started off with, and always center the current match on the
-- screen.
vim.cmd [[nnoremap <expr> n 'Nn'[v:searchforward] . 'zz']]
vim.cmd [[nnoremap <expr> N 'nN'[v:searchforward] . 'zz']]

-- FIXME:
-- vim.api.nvim_set_keymap('n', '<S-h>', '<S-h>5k', { noremap = true, silent = true })

-- TODO: fix, for some reason it's not set
lvim.keys.normal_mode["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>"
