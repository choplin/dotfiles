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
      ensure_installed = {
        "bash",
        "c",
        "dockerfile",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "jsonc",
        "kotlin",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
      },
    },
  },
  -- Show current context at the top of the windows as virtual text
  {
    "nvim-treesitter/nvim-treesitter-context",
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
  {
    "nvim-treesitter/playground",
    cmd = {
      "TSPlaygroundToggle",
      "TSCaptureUnderCursor",
      "TSNodeUnderCursor",
      "TSHighlightCapturesUnderCursor",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {},
      })
    end,
  },
}
