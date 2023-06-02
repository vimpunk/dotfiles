pcall(function()
  local auto_dark_mode = require('auto-dark-mode')
  auto_dark_mode.setup({
    update_interval = 5 * 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option('background', 'dark')
      vim.fn.execute([[!sed -i "" -e 's/^colors: \*.*/colors: \*tokyonight_night/' ~/.config/alacritty/alacritty.yml]])
    end,
    set_light_mode = function()
      vim.api.nvim_set_option('background', 'light')
      vim.fn.execute([[!sed -i "" -e 's/^colors: \*.*/colors: \*tokyonight_day/' ~/.config/alacritty/alacritty.yml]])
    end,
  })
  auto_dark_mode.init()
end)
