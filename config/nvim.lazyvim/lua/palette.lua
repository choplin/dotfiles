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
function M.setup_catpuccin(flavour)
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

return M
