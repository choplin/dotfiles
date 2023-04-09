return {
  -- Provide Github utility commands :Octo
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "Octo" },
    opts = {},
  },
  -- Provide better conflict UI and commands for resolving it
  {
    "akinsho/git-conflict.nvim",
    opts = {},
  },
  -- Provide fancy UI of git commit
  { "rhysd/committia.vim" },
}
