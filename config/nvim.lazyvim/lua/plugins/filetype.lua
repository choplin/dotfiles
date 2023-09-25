return {
  -- Provide markdown preview in browser
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", ft = "markdown" },
  -- Markdown table
  { "dhruvasagar/vim-table-mode", ft = "markdown" },
  -- Zig
  {
    "ziglang/zig.vim",
    ft = "zig",
    config = function()
      vim.g.zig_fmt_autosave = 0
    end,
  },
  -- Scala
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require("plugins.lsp.nvim-metals").setup_autocmd()
    end,
    config = function()
      require("plugins.lsp.nvim-metals").setup_dap()
    end,
  },
}
