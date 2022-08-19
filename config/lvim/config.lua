--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"

vim.opt.list = true
vim.opt.listchars:remove("tab")
vim.opt.listchars:append("tab:￫ ")
vim.opt.listchars:append("extends:»")
vim.opt.listchars:append("precedes:«")
vim.opt.titlestring = [[%{luaeval('require("title_string").title_string()')} - %{v:progname}]]
vim.opt.cmdheight = 1
vim.o.guifont = "HackGen35 Console NFJ:h18"

vim.api.nvim_set_var("did_load_filetypes", 0)
vim.api.nvim_set_var("do_filetype_lua", 1)

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-]>"] = "<Cmd>lua vim.lsp.buf.definition()<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- emacs-like bindings for command line
vim.keymap.set("c", "<C-a>", "<C-b>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-k>", "<C-e><C-u>")
vim.keymap.set("c", "<C-d>", "<Del>")
-- move based on display lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<Up>", "gk")

lvim.builtin.telescope = vim.tbl_deep_extend("keep", {
  defaults = {
    layout_config = {
      width = 0.90,
    },
  },
}, lvim.builtin.telescope)

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["sg"] = { "<cmd>Telescope ghq list<cr>", "ghq list" }
lvim.builtin.which_key.setup.plugins.presets.text_objects = true

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true

lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = "<M-t>"
lvim.builtin.terminal.execs = {
  { "gitui", "<leader>gg", "GitUI", "float" },
  { "gitui", "<c-\\><c-g>", "GitUI", "float" },
  { "tig", "<c-\\><c-t>", "Tig", "float" },
}

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.dap.active = true

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.indent.enable = false -- use yati instead

do
  local components = require("lvim.core.lualine.components")
  lvim.builtin.lualine.sections.lualine_a = { components.branch }
  lvim.builtin.lualine.sections.lualine_b = { components.diff }
  lvim.builtin.lualine.sections.lualine_c = { { "filename", path = 1 } }
  lvim.builtin.lualine.sections.lualine_y = { components.location }
  lvim.builtin.lualine.sections.lualine_z = { components.encoding, "fileformat" }
end
lvim.builtin.lualine.options.globalstatus = true

-- generic LSP settings

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "rust_analyzer", -- Use rust-tools instead
  "yamlls", -- With additional options, setup in ftplugin
})

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- set a formatter, this will override the language server formatting capabilities (if it exists)
do
  local mason_package = require("mason-core.package")

  local formatter_sources = {}
  local linter_sources = {}
  for _, package in ipairs(require("mason-registry").get_installed_packages()) do
    for _, category in ipairs(package.spec.categories) do
      if category == mason_package.Cat.Formatter then
        table.insert(formatter_sources, { name = package.name })
      elseif category == mason_package.Cat.Linter then
        table.insert(linter_sources, { name = package.name })
      end
    end
  end

  require("lvim.lsp.null-ls.formatters").setup(formatter_sources)
  require("lvim.lsp.null-ls.linters").setup(linter_sources)
end

lvim.plugins = require("util").concatLists(
  require("plugins/base"),
  require("plugins/cmp"),
  require("plugins/command"),
  require("plugins/debug"),
  require("plugins/edit"),
  require("plugins/filetype"),
  require("plugins/git"),
  require("plugins/treesitter")
)

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
do
  -- map q to close cmdwin
  local augroup = vim.api.nvim_create_augroup("mygroup", {})
  vim.api.nvim_create_autocmd("CmdWinEnter", {
    group = augroup,
    pattern = "[:/?=]",
    callback = function() vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true }) end,
  })

  -- Quit nvim if the only nvimtree window remains
  vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
      if vim.fn.winnr("$") == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
        vim.cmd("quit")
      end
    end,
  })
end

-- Load local environment specif settings
pcall(require, "local")
