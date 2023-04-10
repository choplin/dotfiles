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
  -- Show current context at the top of the windows as virtual text
  {
    "lewis6991/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Show current context at the closed brackets
  {
    "haringsrob/nvim_context_vt",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Automatically close html tag
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
    },
    opts = {},
  },
  -- Provide treesitter based text object with text hint
  {
    "mfussenegger/nvim-treehopper",
    keys = {
      {
        "m",
        ":<C-U>lua require('tsht').nodes()<CR>",
        mode = "o",
        desc = "Select region with treesitter",
      },
      {
        "m",
        ":lua require('tsht').nodes()<CR>",
        mode = { "o", "v" },
        desc = "Select region with treesitter",
      },
    },
  },
}
