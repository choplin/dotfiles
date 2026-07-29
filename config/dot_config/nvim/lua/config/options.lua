-- Options are loaded before plugins (from init.lua)

-- Auto format
vim.g.autoformat = true

-- Snacks animations (disabled)
vim.g.snacks_animate = false

-- Do not handle Copilot suggestion by blink.cmp
vim.g.ai_cmp = false


local opt = vim.opt

opt.autowrite = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldtext = ""
-- formatexpr: will be set by lib.format when available
-- opt.formatexpr = "v:lua.require'lib'.format.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guifont = "HackGen35 Console NFJ:h18"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3
opt.linebreak = true
opt.list = true
opt.listchars:remove("tab")
opt.listchars:append("tab:￫ ")
opt.listchars:append("extends:»")
opt.listchars:append("precedes:«")
opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 4
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = false
opt.spell = false
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
-- statuscolumn: set by snacks.lua after setup
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 250
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Custom filetype mappings
vim.filetype.add({
  extension = {
    ["h"] = "c",
    ["mdx"] = "markdown",
  },
  filename = {
    ["Tiltfile"] = "tiltfile",
  },
})

-- Disable LSP logging
vim.lsp.log.set_level(vim.log.levels.OFF)
