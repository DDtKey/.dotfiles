return {
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup({
        window = {
          split_ratio = 0.4,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
          position = "vertical",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
          enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
          hide_numbers = true,    -- Hide line numbers in the terminal window
          hide_signcolumn = true, -- Hide the sign column in the terminal window
        },
        -- Keymaps
          keymaps = {
            toggle = {
              normal = "<C-,>",       -- Normal mode keymap for toggling Claude Code, false to disable
              terminal = "<C-,>",     -- Terminal mode keymap for toggling Claude Code, false to disable
              variants = {
                continue = "<leader>aC", -- Normal mode keymap for Claude Code with continue flag
                verbose = "<leader>aV",  -- Normal mode keymap for Claude Code with verbose flag
              },
            },
            window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
            scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
          }
      })

      vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
    end
  },
  {
    'johnseth97/codex.nvim',
    lazy = true,
    cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
    keys = {
      {
        '<leader>ag',
        function() require('codex').toggle() end,
        desc = 'Toggle Codex popup',
      },
    },
    opts = {
      keymaps     = {
        toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
        quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
      },         -- Disable internal default keymap (<leader>cc -> :CodexToggle)
      border      = 'rounded',  -- Options: 'single', 'double', or 'rounded'
      width       = 0.8,        -- Width of the floating window (0.0 to 1.0)
      height      = 0.8,        -- Height of the floating window (0.0 to 1.0)
      model       = nil,        -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
      autoinstall = true,       -- Automatically install the Codex CLI if not found
    },
  }
}
