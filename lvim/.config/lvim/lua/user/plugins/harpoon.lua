lvim.builtin.which_key.mappings["h"] = {
  name = "Harpoon",
  h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" },
  m = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Mark" },
  s = { "<cmd>Telescope harpoon marks<CR>", "Telescope" },
  n = { "<cmd>lua require('harpoon.ui').nav_next()<CR>", "Next" },
  p = { "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "Prev" },
  j = { "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", "Goto 1" },
  k = { "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", "Goto 2" },
  l = { "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", "Goto 3" },
  [";"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", "Goto 4" },
}

pcall(function()
  require("harpoon").setup()
  require("telescope").load_extension("harpoon")
end)
