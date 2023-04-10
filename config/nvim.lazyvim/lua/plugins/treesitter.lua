return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- Better matchit
      "andymass/vim-matchup",
    },
    opts = {
      matchup = {
        enable = true,
      },
    },
  },
}
