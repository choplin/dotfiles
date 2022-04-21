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
vim.api.nvim_set_keymap("c", "<C-a>", "<C-b>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-b>", "<Left>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-f>", "<Right>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-k>", "<C-e><C-u>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-d>", "<Del>", { noremap = true })

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
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
lvim.builtin.which_key.mappings["sg"] = { "<cmd>Telescope ghq list<cr>", "ghq list" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true

lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = "<M-t>"
lvim.builtin.terminal.execs = {
  { "lazygit", "<leader>gg", "LazyGit", "float" },
  { "lazygit", "<c-\\><c-g>", "LazyGit", "float" },
  { "tig", "<leader>gt", "Tig", "float" },
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
  local gps = require("nvim-gps")
  lvim.builtin.lualine.sections.lualine_z = { components.encoding, "fileformat" }
  lvim.builtin.lualine.sections.lualine_c = { components.diff, { gps.get_location, cond = gps.is_available } }
end
lvim.builtin.lualine.options.globalstatus = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

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

-- Additional Plugins
lvim.plugins = {
  { "folke/tokyonight.nvim" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "kevinhwang91/nvim-hlslens", config = function()
      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end
  },
  {
    "petertriho/nvim-scrollbar", after = { "nvim-hlslens" }, config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
      lvim.builtin.which_key.mappings["h"] = { [[<Cmd>nohlsearch<CR><Cmd>lua require('scrollbar_ext').hide_search_results()<CR>]], "No Highlight" }
    end
  },
  {
    "nvim-telescope/telescope-ghq.nvim", config = function()
      require 'telescope'.load_extension 'ghq'
    end
  },
  { "cappyzawa/starlark.vim", ft = "starlark" },
  -- { "EdenEast/nightfox.nvim", tag = "v1.0.0" },
  {
    "hrsh7th/cmp-cmdline",
    require = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require "cmp"
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'cmdline' }
        }
      })
    end
  },
  { "hrsh7th/cmp-nvim-lsp-document-symbol",
    require = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-cmdline" },
    config = function()
      local cmp = require "cmp"
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" }
        }, {
          { name = "buffer" }
        })
      })
    end,
  },
  { "github/copilot.vim" },
  { "zbirenbaum/copilot.lua" },
  {
    "zbirenbaum/copilot-cmp",
    event  = "InsertEnter",
    after  = { "copilot.vim", "copilot.lua", "nvim-cmp" },
    config = function()
      vim.schedule(function()
        require("copilot").setup({
          plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
        })
        table.insert(lvim.builtin.cmp.sources, { name = "copilot" })
      end)
    end
  },
  { "hrsh7th/cmp-emoji", event = "InsertEnter", config = function() table.insert(lvim.builtin.cmp.sources, { name = "emoji" }) end },
  { 'tzachar/cmp-tabnine', event = "InsertEnter", run = './install.sh', requires = 'hrsh7th/nvim-cmp' },
  { "folke/todo-comments.nvim", config = function() require("todo-comments").setup() end },
  { "ggandor/lightspeed.nvim" },
  -- { "windwp/nvim-spectre" },
  { 'sindrets/diffview.nvim', cmd = { "DiffviewOpen", "DiffviewFileHistory" }, requires = 'nvim-lua/plenary.nvim' },
  { 'j-hui/fidget.nvim', config = function() require('fidget').setup() end },
  {
    "yioneko/nvim-yati", evnet = "InsertEnter", requires = "nvim-treesitter/nvim-treesitter", config = function()
      require("nvim-treesitter.configs").setup { yati = { enable = true } }
    end
  },
  {
    "romgrk/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter", config = function()
      require 'treesitter-context'.setup()
    end
  },
  { "haringsrob/nvim_context_vt" },
  {
    "mfussenegger/nvim-ts-hint-textobject", config = function()
      vim.api.nvim_set_keymap("o", "m", "<cmd>lua require('tsht').nodes()<cr>", { silent = true })
      vim.api.nvim_set_keymap("v", "m", ":lua require('tsht').nodes()<cr>", { silent = true, noremap = true })
    end
  },
  {
    "David-Kunz/treesitter-unit", config = function()
      vim.api.nvim_set_keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', { noremap = true })
      vim.api.nvim_set_keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', { noremap = true })
    end
  },
  {
    "RRethy/nvim-treesitter-textsubjects", config = function()
      require('nvim-treesitter.configs').setup {
        textsubjects = {
          enable = true,
          prev_selection = ',',
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
          },
        }
      }
    end
  },
  {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      local gps = require("nvim-gps")
      gps.setup()
    end,
  },
  -- { "sidebar-nvim/sidebar.nvim", event = "BufEnter", config = function() require "sidebar-nvim".setup { open = false } end },
  { "gbprod/substitute.nvim", after = "yanky.nvim", config = function()
    require("substitute").setup {
      on_substitute = function(event)
        require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
      end
    }
    vim.api.nvim_set_keymap("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
    vim.api.nvim_set_keymap("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
    vim.api.nvim_set_keymap("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
    vim.api.nvim_set_keymap("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
  end },
  { "gbprod/yanky.nvim", config = function()
    require("yanky").setup()
    vim.api.nvim_set_keymap("n", "p", "<Plug>(YankyPutAfter)", {})
    vim.api.nvim_set_keymap("n", "P", "<Plug>(YankyPutBefore)", {})
    vim.api.nvim_set_keymap("x", "p", "<Plug>(YankyPutAfter)", {})
    vim.api.nvim_set_keymap("x", "P", "<Plug>(YankyPutBefore)", {})
    vim.api.nvim_set_keymap("n", "gp", "<Plug>(YankyGPutAfter)", {})
    vim.api.nvim_set_keymap("n", "gP", "<Plug>(YankyGPutBefore)", {})
    vim.api.nvim_set_keymap("x", "gp", "<Plug>(YankyGPutAfter)", {})
    vim.api.nvim_set_keymap("x", "gP", "<Plug>(YankyGPutBefore)", {})
    vim.api.nvim_set_keymap("n", "<c-n>", "<Plug>(YankyCycleForward)", {})
    vim.api.nvim_set_keymap("n", "<c-p>", "<Plug>(YankyCycleBackward)", {})
    vim.api.nvim_set_keymap("n", "y", "<Plug>(YankyYank)", {})
    vim.api.nvim_set_keymap("x", "y", "<Plug>(YankyYank)", {})
  end }
}


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
  { "CmdWinEnter", "[:/?=]", [[nnoremap <buffer> q <Cmd>q<CR>]] }
}
