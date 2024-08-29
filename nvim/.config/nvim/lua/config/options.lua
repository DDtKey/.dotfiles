-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable auto-formatting globally (to enable on per-filetype basis, see autocmds)
vim.g.autoformat = false

-- Enable colorcolumn
vim.api.nvim_set_option_value("colorcolumn", "120", {})
