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

vim.api.nvim_set_var("did_load_filetypes", 0)
vim.api.nvim_set_var("do_filetype_lua", 1)

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-]>"] = "<Cmd>lua vim.lsp.buf.definition()<CR>"
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

-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["sg"] = { "<cmd>Telescope ghq list<cr>", "ghq list" }
lvim.builtin.which_key.setup.plugins.presets.text_objects = true

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
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
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.dap.active = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
  "go",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.indent.enable = false -- use yati instead

do
  local components = require("lvim.core.lualine.components")
  lvim.builtin.lualine.sections.lualine_z = { components.encoding, "fileformat" }
  lvim.builtin.lualine.sections.lualine_c = { components.diff }
end
lvim.builtin.lualine.options.globalstatus = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
table.insert(lvim.lsp.automatic_configuration.skipped_servers, "rust_analyzer") -- Use rust-tools instead


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

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

lvim.plugins = require('util').concatLists(
  require('plugins/base'),
  require('plugins/cmp'),
  require('plugins/command'),
  require('plugins/debug'),
  require('plugins/edit'),
  require('plugins/filetype'),
  require('plugins/git'),
  require('plugins/treesitter')
)


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
do
  local augroup = vim.api.nvim_create_augroup("mygroup", {})
  vim.api.nvim_create_autocmd("CmdWinEnter", {
    group = augroup,
    pattern = "[:/?=]",
    command = [[nnoremap <buffer> q <Cmd>q<CR>]],
  })
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
