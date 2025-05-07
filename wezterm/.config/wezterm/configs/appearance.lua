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
            -- blue (tokyonight moon):
              -- "#24283b",
              -- "#1f2335"
            -- gray (darcula JetBrains)
              -- "#484848", -- dark gray
              "#383838" -- bck color
					},
					interpolation = 'Linear',
					blend = 'Rgb',
				},
			},
      height = '100%',
      width = '100%'
		},
    {
      source = {
        File = { path = wp.current_wallpaper() }
      },
      hsb = {
        brightness = 1.0,
        saturation = 1.0,
      },
      horizontal_align = "Center",
      vertical_align = "Middle",
      opacity = 0.12,
    }
  }
end

M.change_wallpaper = function()
  wp.update_wallpaper()
  wezterm.reload_configuration()
end

return M
