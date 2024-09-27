local M = {}

local wezterm = require('wezterm')

-- Load custom modules
local wp = require("modules/wallpapers")

M.apply_to_config = function(config)
  config.font = wezterm.font("JetBrainsMono Nerd Font")
  config.font_size = 14
  config.color_scheme = "Tokyo Night Moon"
  --config.enable_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true

  config.window_decorations = "RESIZE"

  config.macos_window_background_blur = 10
  config.background = {
		{
			source = {
				Gradient = {
					orientation = 'Vertical',
					colors = {
            "#24283b",
            "#1f2335"
					},
					interpolation = 'Linear',
					blend = 'Rgb',
				},
			},
      height = '100%',
      width = '100%'
		},
    wp.random_wallpaper(wezterm.config_dir .. "/wallpapers/**"),
  }
end

return M
