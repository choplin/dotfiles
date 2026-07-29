-- [Lang] Zig language support (syntax, filetype detection).
return {
  "zig.vim",
  src = "https://github.com/ziglang/zig.vim",
  ft = "zig",
  before = function()
    vim.g.zig_fmt_autosave = 0
  end,
}
