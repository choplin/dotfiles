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
  -- Show current context at the closed brackets
  {
    "haringsrob/nvim_context_vt",
    event = { "BufReadPost", "BufNewFile" },
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
