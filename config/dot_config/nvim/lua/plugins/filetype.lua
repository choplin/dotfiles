return {
  -- Markdown table
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    config = function()
      -- vim.g.table_mode_disable_mappings = true
      -- vim.g.table_mode_always_active = true
    end,
  },
  -- Zig
  {
    "ziglang/zig.vim",
    ft = "zig",
    config = function()
      vim.g.zig_fmt_autosave = 0
    end,
  },
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
  },
}
