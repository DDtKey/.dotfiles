-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Load event handlers
require('events.right-status').setup()

-- Apply configs
require('configs.appearance').apply_to_config(config)

-- and finally, return the configuration to wezterm
return config
