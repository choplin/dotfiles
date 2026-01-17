-- Git files support
return {
  -- Treesitter git support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "git_config", "gitcommit", "git_rebase", "gitignore", "gitattributes" } },
  },

  -- Git completion source (via blink.compat)
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "petertriho/cmp-git", opts = {} },
    },
    opts = {
      sources = {
        compat = { "git" },
        providers = {
          git = {
            name = "git",
            module = "blink.compat.source",
          },
        },
        per_filetype = {
          gitcommit = { inherit_defaults = true, "git" },
        },
      },
    },
  },
}
