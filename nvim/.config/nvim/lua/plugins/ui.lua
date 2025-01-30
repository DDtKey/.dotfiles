return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-storm",
      -- colorscheme = "starry",
      -- colorscheme = "catppuccin-macchiato",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = vim.g.transparent_enabled,
      style = "night",
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
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
    "catppuccin",
    opts = {
      transparent_background = vim.g.transparent_enabled,
    },
  },
  {
    "ray-x/starry.nvim",
    opts = function(_, opts)
      local config = {
        disable = {
          -- background = vim.g.transparent_enabled,
          background = true
        }
      }

      require('starry').setup(config)
    end,
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
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = function(_, opts)
      -- table: default groups
      opts.groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn',
        -- 'CursorLine', 'CursorLineNr',
        -- 'StatusLine', 'StatusLineNC',
        'EndOfBuffer',
      }
      -- table: additional groups that should be cleared
      opts.extra_groups = {
        "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
        "FloatBorder", -- border of float panels
        "NeoTreeNormal", "NeoTreeNormalNC", -- NeoTree
        "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder", -- Telescope
        "LspFloatWinNormal", -- Lsp Floating window
      }
      -- table: groups you don't want to clear
      opts.exclude_groups = {
        "lualine",
      }
      -- function: code to be executed after highlight groups are cleared
      -- Also the user event "TransparentClear" will be triggered
      opts.on_clear = function() end
    end
  },
}
