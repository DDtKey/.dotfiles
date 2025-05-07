-- Pull in the wezterm API
local wezterm = require("wezterm")
local appearance = require("configs.appearance")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Load event handlers
require('events.right-status').setup()

-- Apply configs
appearance.apply_to_config(config)

-- Wallpaper change event
wezterm.on("change-wallpaper", function(window, pane)
  appearance.change_wallpaper()
end)

-- Keybinding to change wallpaper
config.keys = {
  {key="w", mods="ALT|SHIFT", action=wezterm.action.EmitEvent("change-wallpaper")},
}


-- and finally, return the configuration to wezterm
return config
