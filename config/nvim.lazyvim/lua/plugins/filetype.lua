return {
  -- Provide markdown preview in browser
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", ft = "markdown" },
  -- Markdown table
  { "dhruvasagar/vim-table-mode", ft = "markdown" },
  -- Zig
  { "ziglang/zig.vim", ft = "zig" },
}
