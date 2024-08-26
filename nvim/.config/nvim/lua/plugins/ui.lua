return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.border = colors.white
      end,
    },
  },
  {
      "nvim-lualine/lualine.nvim",
      opts = {
          options = {
              theme = "ayu_mirage",
              component_separators = "",
              section_separators = { left = "", right = "" },
          },
          sections = {
              lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
              lualine_y = {
                  { "progress", separator = " ", padding = { left = 1, right = 0 } },
                  { "location", padding = { left = 0, right = 1 } },
              },
              lualine_z = {
                  {
                      --function()
                      --  --return " " .. os.date("%R")
                      --end,
                    "encoding", separator = { right = "" },
                  },
              },
          },
      },
  },
}
