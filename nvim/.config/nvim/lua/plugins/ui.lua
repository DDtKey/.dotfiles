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
          fg = colors.comment,
        }
        hl.LineNrBelow = {
          fg = colors.comment,
        }
        hl.CursorLineNr = {
          fg = colors.orange,
        }
        hl.ColorColumn = {
          bg = colors.bg_highlight,
        }
        hl.NeoTreeDotfile = {
          fg = colors.comment,
        }
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- opts.options.theme = "ayu_mirage"
      opts.options.component_separators = { left = "", right = "" }
      opts.options.section_separators = { left = "", right = "" }

      opts.sections.lualine_a = {{
        "mode",
        separator = { left = "" },
        right_padding = 2,
      }}

      opts.sections.lualine_z = {{
        "encoding",
        separator = { right = "" },
      }}
    end,
  },
}
