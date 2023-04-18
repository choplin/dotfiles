-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.listchars:remove("tab")
opt.listchars:append("tab:￫ ")
opt.listchars:append("extends:»")
opt.listchars:append("precedes:«")
opt.timeoutlen = 250
opt.guifont = "HackGen35 Console NFJ:h18"

vim.filetype.add({
  filename = {
    ["Tiltfile"] = "tiltfile",
  },
})
