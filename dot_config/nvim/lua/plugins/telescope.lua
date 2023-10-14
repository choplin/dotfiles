return {
  {
    "nvim-telescope/telescope-frecency.nvim",
    lazy = true,
    dependencies = { "kkharji/sqlite.lua" },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>sf", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Frecency (cwd)" },
      { "<leader>sF", "<cmd>Telescope frecency", desc = "Frecency (global)" },
    },
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    opts = {
      defaults = {
        layout_config = {
          width = 0.90,
        },
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<C-n>"] = require("telescope.actions").cycle_history_next,
            ["<C-p>"] = require("telescope.actions").cycle_history_prev,
          },
        },
        path_display = { "truncate" },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("frecency")
    end,
  },
}
