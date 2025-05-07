local wezterm = require("wezterm")
local M = {}

math.randomseed(os.time())

-- State to track the current wallpaper index
local current_index = wezterm.GLOBAL.current_wallpaper_index or nil

M.next_wallpaper = function(dir)
  local wallpapers = {}
  for _, v in ipairs(wezterm.glob(dir)) do
    -- Ignore DS_Store
    if not string.match(v, "%.DS_Store$") then
      table.insert(wallpapers, v)
    end
  end

  -- Initialize index if not set (random on initial load)
  if not current_index then
    current_index = math.random(#wallpapers)
  else
    -- Move to the next wallpaper, loop back to the first if at the end
    current_index = (current_index % #wallpapers) + 1
  end

  wezterm.GLOBAL.current_wallpaper_index = current_index
  wezterm.GLOBAL.current_wallpaper = wallpapers[current_index]

  return wezterm.GLOBAL.current_wallpaper
end

M.update_wallpaper = function()
  M.next_wallpaper(wezterm.config_dir .. "/wallpapers/**")
end

M.current_wallpaper = function()
  return wezterm.GLOBAL.current_wallpaper or M.update_wallpaper()
end


return M
