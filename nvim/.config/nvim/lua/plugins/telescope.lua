return {
  {
    "princejoogie/dir-telescope.nvim",
    -- telescope.nvim is a required dependency
    requires = {"nvim-telescope/telescope.nvim"},
    config = function()
      require("dir-telescope").setup({
        -- these are the default options set
        hidden = true,
        no_ignore = false,
        show_preview = true,
      })
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    -- telescope.nvim is a required dependency
    requires = {"nvim-telescope/telescope.nvim"},
    config = function()
      LazyVim.on_load("telescope.nvim", function()
        require(
          "telescope"
        ).load_extension("live_grep_args")
      end)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>/",
        function()
          require(
            "telescope"
          ).extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep with Args (root dir)",
      },
    },
    opts = {
      extensions = {
        live_grep_args = {
          mappings = {
            i = {
              ["<C-k>"] = function(picker)
                require(
                  "telescope-live-grep-args.actions"
                ).quote_prompt()(picker)
              end,
            },
          },
        },
      },
    },
  }
}
