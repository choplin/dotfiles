return {
  -- :SnipRun runs code instantly
  { "michaelb/sniprun", build = "bash ./install.sh", cmd = "SnipRun" },
  -- :Neogen generates documentation comments
  {
    "danymat/neogen",
    cmd = "Neogen",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  -- Aerial to display symbol outline
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      {
        "<leader>co",
        function()
          require("aerial").toggle()
        end,
        desc = "Symbols Outline",
      },
    },
    opts = {
      show_guides = true,
    },
  },
  -- Task Runner
  {
    "stevearc/overseer.nvim",
    cmd = "OverseerRun",
    opts = {
      templates = { "builtin" },
    },
  },
}
