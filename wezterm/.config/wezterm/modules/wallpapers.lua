local wezterm = require("wezterm")
local M = {}

M.random_wallpaper = function(dir)
	local wallpapers = {}
	for _, v in ipairs(wezterm.glob(dir)) do
		-- Ignore DS_Store
		if not string.match(v, "%.DS_Store$") then
			table.insert(wallpapers, v)
		end
	end
	local rnd_wallpaper = wallpapers[math.random(#wallpapers)]
	return {
		source = {
			File = { path = rnd_wallpaper },
		},
		hsb = {
			brightness = 0.09,
      saturation = 0.8,
		},
		horizontal_align = "Center",
    vertical_align = "Middle",
		opacity = 1.0,
	}
end

return M
