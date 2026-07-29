local M = {}

--- @class MyPalette
--- @field public fg string
--- @field public fg_dark string
--- @field public bg string
--- @field public bg_dark string
--- @field public green string
--- @field public red string
--- @field public blue string
--- @field public orange string

--- @type MyPalette
M.palette = {
  fg = "",
  fg_dark = "",
  bg = "",
  bg_dark = "",
  green = "",
  red = "",
  blue = "",
  orange = "",
}

function M.setup_tokyonight()
  local p = require("tokyonight.colors").setup()
  M.palette = {
    fg = p.fg,
    fg_dark = p.fg_dark,
    bg = p.bg,
    bg_dark = p.bg_dark,
    green = p.green,
    red = p.red,
    blue = p.blue,
    orange = p.orange,
  }
end

--- @param flavour? string
--- | '"latte"'
--- | '"frappe"'
--- | '"macchiato"'
--- | '"mocha"'
function M.setup_catppuccin(flavour)
  local p = require("catppuccin.palettes").get_palette(flavour)
  M.palette = {
    fg = p.text,
    fg_dark = p.overlay1,
    bg = p.base,
    bg_dark = p.mantle,
    green = p.green,
    red = p.red,
    blue = p.blue,
    orange = p.peach,
  }
end

--- Sync the shared palette from the active colorscheme name.
function M.setup_from_colorscheme()
  local name = vim.g.colors_name or ""
  if name:find("tokyonight", 1, true) then
    M.setup_tokyonight()
  elseif name:find("catppuccin", 1, true) then
    local flavour = name:match("catppuccin%-(%w+)") or vim.g.catppuccin_flavour or "mocha"
    M.setup_catppuccin(flavour)
  end
end

--- Keep palette and theme-dependent consumers in sync after `:colorscheme`.
function M.watch_colorscheme()
  if M._watching then
    return
  end
  M._watching = true
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("lib_palette_colorscheme", { clear = true }),
    callback = function()
      M.setup_from_colorscheme()
    end,
  })
  M.setup_from_colorscheme()
end

return M
