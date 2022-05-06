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
  { "gitui", "<leader>gg", "GitUI", "float" },
  { "gitui", "<c-\\><c-g>", "GitUI", "float" },
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
      local kopts = { silent = true }
      vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
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
  {
    "windwp/nvim-spectre", event = "BufRead", config = function()
      vim.keymap.set("n", "<leader>S", function() require("spectre").open_file_search() end)
    end
  },
  { 'sindrets/diffview.nvim', cmd = { "DiffviewOpen", "DiffviewFileHistory", "Neogit" }, requires = 'nvim-lua/plenary.nvim' },
  { 'j-hui/fidget.nvim', config = function() require('fidget').setup() end },
  {
    "yioneko/nvim-yati", evnet = "InsertEnter", requires = "nvim-treesitter/nvim-treesitter", config = function()
      require("nvim-treesitter.configs").setup { yati = { enable = true } }
    end
  },
  {
    "lewis6991/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter", config = function()
      require 'treesitter-context'.setup()
    end
  },
  { "haringsrob/nvim_context_vt" },
  {
    "mfussenegger/nvim-ts-hint-textobject", config = function()
      vim.keymap.set({ "o", "v" }, "m", function() require('tsht').nodes() end, { silent = true })
    end
  },
  {
    "David-Kunz/treesitter-unit", config = function()
      vim.keymap.set({ "x", "o" }, "iu", function() require "treesitter-unit".select() end)
      vim.keymap.set({ "x", "o" }, "au", function() require "treesitter-unit".select(true) end)
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

      local components = require("lvim.core.lualine.components")
      lvim.builtin.lualine.sections.lualine_c = { components.diff, { gps.get_location, cond = gps.is_available } }
    end,
  },
  -- { "sidebar-nvim/sidebar.nvim", event = "BufEnter", config = function() require "sidebar-nvim".setup { open = false } end },
  { "gbprod/substitute.nvim", after = "yanky.nvim", config = function()
    require("substitute").setup {
      on_substitute = function(event)
        require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
      end
    }
    vim.keymap.set("n", "s", function() require('substitute').operator() end)
    vim.keymap.set("n", "ss", function() require('substitute').line() end)
    vim.keymap.set("n", "S", function() require('substitute').eol() end)
    vim.keymap.set("x", "s", function() require('substitute').visual() end)
  end },
  { "gbprod/yanky.nvim", config = function()
    require("yanky").setup()
    vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
    vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
    vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
    vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
  end },
  { "monaqa/dial.nvim", config = function()
    vim.keymap.set({ "n", "v" }, "<C-a>", require("dial.map").inc_normal())
    vim.keymap.set({ "n", "v" }, "<C-x>", require("dial.map").dec_normal())
    vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual())
    vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual())
  end },
  -- TODO: set keymaps that can enable both hlslens and vim-asterisk
  { "haya14busa/vim-asterisk", config = function()
    vim.keymap.set({ "n", "v", "o" }, "*", "<Plug>(asterisk-z*)")
    vim.keymap.set({ "n", "v", "o" }, "#", "<Plug>(asterisk-z#)")
    vim.keymap.set({ "n", "v", "o" }, "g*", "<Plug>(asterisk-gz*)")
    vim.keymap.set({ "n", "v", "o" }, "g#", "<Plug>(asterisk-gz#)")
  end },
  { "chentau/marks.nvim", config = function() require 'marks'.setup {} end },
  { "lukas-reineke/indent-blankline.nvim", config = function()
    vim.opt.termguicolors = true
    vim.cmd [[highlight IndentBlanklineIndent1 guibg=#24283b gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1f2335 gui=nocombine]]
    require("indent_blankline").setup {
      char = "",
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
      },
      space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
      },
      show_trailing_blankline_indent = false,
    }
  end },
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },
  {
    "andymass/vim-matchup",
    config = function()
      require "nvim-treesitter.configs".setup { matchup = { enable = true } }
    end
  },
  { "windwp/nvim-ts-autotag", config = function() require("nvim-ts-autotag").setup() end,
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue", "tsx", "jsx", "rescript", "xml", } },
  {
    "klen/nvim-test",
    cmd = { "TestSuite", "TestFile", "TestEdit", "TestNearest", "TestLast", "TestVisit", "TestInfo" },
    config = function()
      require("nvim-test").setup {
        term = "toggleterm",
        termOpts = { direction = "float" },
      }
    end
  },
  { "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins", cmd = { "Ultest" } },
  { "michaelb/sniprun", run = "bash ./install.sh", cmd = "SnipRun" },
  { "gpanders/editorconfig.nvim" },
  {
    "stevearc/aerial.nvim",
    config = function() require("aerial").setup {
        on_attach = function(bufnr)
          -- Toggle the aerial window with <leader>a
          vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
          -- Jump forwards/backwards with "{" and "}"
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end
      }
    end
  },
  { "TimUntersberger/neogit", requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" }, cmd = "Neogit",
    config = function() require("neogit").setup { integrations = { diffview = true } } end },
  { 'akinsho/git-conflict.nvim', config = function() require('git-conflict').setup() end },
  { "rhysd/committia.vim" },
  { "hotwatermorning/auto-git-diff" },
  -- { "rcarriga/nvim-dap-ui" },
  -- { "theHamsta/nvim-dap-virtual-text" },
  -- { "theHamsta/nvim-dap-virtual-text" },
  {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function() require "octo".setup() end
  },
  -- { "simrat39/rust-tools.nvim", ft = "rust", config = function() require('rust-tools').setup {} end }
  { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', ft = 'markdown' },
  { "tpope/vim-repeat" },
  { "kevinhwang91/rnvimr", config = function()
    vim.keymap.set({ "n", "t" }, "<M-o>", "<Cmd>RnvimrToggle<CR>", { silent = true })
    vim.keymap.set("t", "<M-i>", "<Cmd>RnvimrResize<CR>", { silent = true })
    vim.g.rnvimr_enable_ex = true
    vim.g.rnvimr_enable_picker = true
    vim.g.rnvimr_layout = {
      ['relative'] = 'editor',
      ['width'] = vim.fn.float2nr(vim.fn.round(vim.o.columns * 0.9)),
      ['height'] = vim.fn.float2nr(vim.fn.round(vim.o.lines * 0.9)),
      ['col'] = vim.fn.float2nr(vim.fn.round(vim.o.columns * 0.05)),
      ['row'] = vim.fn.float2nr(vim.fn.round(vim.o.lines * 0.05)),
      ['style'] = 'minimal'
    }
  end },
  { "ron-rs/ron.vim" },
  {
    "klen/nvim-config-local", config = function()
      require('config-local').setup {
        lookup_parents = true,
        config_files = { ".vimrc.lua" }
      }
    end
  },
  { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }, config = function()
    local metals_config = require("metals").bare_config()
    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    }

    metals_config.init_options.statusBarProvider = "on"
    table.insert(lvim.builtin.lualine.sections.lualine_c, 'g:metals_status')
    require("lvim.core.lualine").setup()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
    require("dap").configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
          runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }
    metals_config.on_attach = function(client, bufnr)
      require("metals").setup_dap()
    end

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end }
}


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  -- { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
  { "CmdWinEnter", "[:/?=]", [[nnoremap <buffer> q <Cmd>q<CR>]] }
}

-- Load local environment specif settings
pcall(require, "local")
