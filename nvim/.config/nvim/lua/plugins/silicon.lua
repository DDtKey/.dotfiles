return {
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>sc", ":Silicon<CR>", desc = "Snapshot Code", mode = "v" },
      })
    end,
    config = function(_)
      require("silicon").setup({
        font = "JetBrainsMono Nerd Font=34;Noto Color Emoji=34",
      })
    end,
  },
}
