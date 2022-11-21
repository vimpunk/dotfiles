pcall(function()
  local auto_dark_mode = require('auto-dark-mode')
  auto_dark_mode.setup({
    update_interval = 10 * 1000,
  })
  auto_dark_mode.init()
end)
