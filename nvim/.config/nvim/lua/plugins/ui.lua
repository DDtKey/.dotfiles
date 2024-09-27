return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      style = "night",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.border = colors.white
        colors.comment = "#aaaaaa"
      end,
      on_highlights = function(hl, colors)
        hl.LineNrAbove = {
          fg = colors.comment
        }
        hl.LineNrBelow = {
          fg = colors.comment
        }
        hl.CursorLineNr = {
          fg = colors.orange
        }
        hl.ColorColumn = {
          bg = colors.bg_highlight
        }
        hl.NeoTreeDotfile = {
          fg = colors.comment
        }
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
