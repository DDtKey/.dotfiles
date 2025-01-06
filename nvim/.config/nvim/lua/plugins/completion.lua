return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- These plugins provided by LazyVim, can be turned on on demand (or outside of lazyvim)
      -- { "hrsh7th/cmp-nvim-lsp" },
      -- { "hrsh7th/cmp-buffer" },
      -- { "hrsh7th/cmp-path" },
      -- {
      --   "garymjr/nvim-snippets",
      --   opts = {
      --     friendly_snippets = true,
      --   },
      --   dependencies = { "rafamadriz/friendly-snippets" },
      -- },
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          completion = {
            cmp = { enabled = true },
          },
        },
        { "hrsh7th/cmp-emoji" },
      },
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      -- table.insert(opts.sources, { name = "nvim_lsp" })
      -- table.insert(opts.sources, { name = "buffer" })
      -- table.insert(opts.sources, { name = "path" })
      -- table.insert(opts.sources, { name = "snippets" })
      table.insert(opts.sources, { name = "crates" })
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "hrsh7th/cmp-cmdline",
    config = function()
      local cmp = require("cmp")
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-j>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          },
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
}
