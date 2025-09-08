return {
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
    })

    vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
  end
}
