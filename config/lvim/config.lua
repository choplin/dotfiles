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
lvim.colorscheme = "tokyonight-moon"

vim.opt.list = true
vim.opt.listchars:remove "tab"
vim.opt.listchars:append "tab:￫ "
vim.opt.listchars:append "extends:»"
vim.opt.listchars:append "precedes:«"
vim.opt.timeoutlen = 250
vim.opt.guifont = "HackGen35 Console NFJ:h18"
vim.opt.cmdheight = 1

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-]>"] = "<Cmd>lua vim.lsp.buf.definition()<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- emacs-like bindings for command line
vim.keymap.set("c", "<C-a>", "<C-b>", {})
vim.keymap.set("c", "<C-b>", "<Left>", {})
vim.keymap.set("c", "<C-f>", "<Right>", {})
vim.keymap.set("c", "<C-k>", "<C-e><C-u>", {})
vim.keymap.set("c", "<C-d>", "<Del>", {})
-- move based on display lines
vim.keymap.set("n", "j", "gj", {})
vim.keymap.set("n", "k", "gk", {})
vim.keymap.set("n", "<Down>", "gj", {})
vim.keymap.set("n", "<Up>", "gk", {})
vim.keymap.set("n", "<Esc>", ":<C-u>nohlsearch<CR>", { silent = true })

do
  local actions = require "telescope.actions"
  lvim.builtin.telescope = vim.tbl_deep_extend("keep", {
    defaults = {
      layout_config = {
        width = 0.90,
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
        },
      },
      path_display = { "truncate" },
    },
  }, lvim.builtin.telescope)
end
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "ghq")
  pcall(telescope.load_extension, "yank_history")
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "symbols")
end

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["sg"] = { "<cmd>Telescope ghq list<cr>", "ghq list" }
lvim.builtin.which_key.mappings["s/"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer Fuzzy Find" }
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets = {
  operators = true, -- adds help for operators like d, y, ...
  motions = true, -- adds help for motions
  text_objects = true, -- help for text objects triggered after entering an operator
  windows = true, -- default bindings on <c-w>
  nav = true, -- misc bindings to work with windows
  z = true, -- bindings for folds, spelling and others prefixed with z
  g = false, -- bindings for prefixed with g
}
lvim.builtin.which_key.mappings["B"] = lvim.builtin.which_key.mappings["b"]
lvim.builtin.which_key.mappings["b"] = {
  function()
    require("telescope.builtin").buffers {
      initial_mode = "insert",
    }
  end,
  "Find Buffer",
}

lvim.builtin.terminal.open_mapping = "<M-t>"
lvim.builtin.terminal.execs = {
  { "tig", "<c-\\><c-t>", "Tig", "float" },
  { "tig status", "<c-\\><c-s>", "Tig Status", "float" },
  { "tig refs", "<c-\\><c-b>", "Tig Branch", "float" },
  { "git diff", "<c-\\><c-d>", "Git Diff", "float" },
}

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.group_empty = true
lvim.builtin.dap.on_config_done = function()
  lvim.builtin.which_key.mappings["dU"] = {
    function()
      require("dapui").toggle()
    end,
    "Toggle UI",
  }
end

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.indent.enable = false -- use yati instead

do
  local components = require "lvim.core.lualine.components"
  local branch = require "lualine_branch"
  lvim.builtin.lualine.sections.lualine_a = { components.mode }
  lvim.builtin.lualine.sections.lualine_b = { { branch, color = { gui = "bold" } }, components.diff }
  lvim.builtin.lualine.sections.lualine_c = { components.diagnostics }
  lvim.builtin.lualine.sections.lualine_x = {
    components.treesitter,
    components.lsp,
    components.filetype,
  }
  lvim.builtin.lualine.sections.lualine_y = { components.location }
  lvim.builtin.lualine.sections.lualine_z = {}
  lvim.builtin.lualine.inactive_sections = vim.deepcopy(lvim.builtin.lualine.sections)
  lvim.builtin.lualine.options.globalstatus = false
end

lvim.builtin.indentlines.options.char = ""
lvim.builtin.indentlines.options.char_highlight_list = {
  "IndentBlanklineIndent1",
  "IndentBlanklineIndent2",
}
lvim.builtin.indentlines.options.space_char_highlight_list = {
  "IndentBlanklineIndent1",
  "IndentBlanklineIndent2",
}
lvim.builtin.indentlines.options.show_trailing_blankline_indent = false
lvim.builtin.indentlines.on_config_done = function()
  vim.cmd [[highlight IndentBlanklineIndent1 guibg=#24283b gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1f2335 gui=nocombine]]
end

lvim.builtin.bufferline.options.always_show_bufferline = true

lvim.builtin.project.on_config_done = function()
  vim.opt.titlestring = [[%{luaeval('require("title_string").title_string()')} - %{v:progname}]]
end

-- generic LSP settings

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheReset` to take effect.
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "rust_analyzer", -- Use rust-tools instead
  "yamlls", -- With additional options, setup in ftplugin
  "jdtls", -- Use nvim-jdtls instead
})

-- set a formatter, this will override the language server formatting capabilities (if it exists)
do
  local mason_package = require "mason-core.package"

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
  require "plugins/base",
  require "plugins/cmp",
  require "plugins/command",
  require "plugins/debug",
  require "plugins/edit",
  require "plugins/filetype",
  require "plugins/git",
  require "plugins/treesitter"
)

-- Commnads
local term_with_buf_file = function(cmd, bufnr)
  return function()
    local name = vim.api.nvim_buf_get_name(bufnr)
    local cmd_with_name = cmd .. " " .. name
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new { cmd = cmd_with_name, close_on_exit = true }
    term:toggle()
  end
end

local open_broot = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new { cmd = "broot", direction = "float", env = { EDITOR = "nvr -l" } }
  term:toggle(lvim.builtin.terminal.size)
end

vim.api.nvim_create_user_command("GitBlame", term_with_buf_file("tig blame", 0), {})
vim.api.nvim_create_user_command("GitFileHistory", term_with_buf_file("tig", 0), {})
vim.api.nvim_create_user_command("Broot", open_broot, { desc = "Broot" })

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
do
  -- map q to close cmdwin
  local augroup = vim.api.nvim_create_augroup("mygroup", {})
  vim.api.nvim_create_autocmd("CmdWinEnter", {
    group = augroup,
    pattern = "[:/?=]",
    callback = function()
      vim.keymap.set("n", "q", "<Cmd>q<CR>", { buffer = true })
    end,
  })

  -- Quit nvim if the only nvimtree window remains
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    nested = true,
    callback = function()
      if vim.fn.winnr "$" == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
        vim.cmd "quit"
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "\\[dap-repl\\]",
    callback = function()
      -- vim.api.nvim_buf_set_option(0, "buftype", "prompt")
      vim.keymap.set("n", "q", "<Cmd>bdelete!<CR>", { buffer = true })
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "*.md",
    callback = function()
      vim.api.nvim_buf_create_user_command(0, "Glow", term_with_buf_file("glow -p", 0), {})
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "diffview://*",
    callback = function()
      vim.keymap.set("n", "<C-q>", "<Cmd>DiffviewClose<CR>", { buffer = true })
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "toggleterm",
    callback = function()
      vim.keymap.set("t", "<C-j>", "<C-j>", { buffer = true })
      vim.keymap.set("t", "<C-k>", "<C-k>", { buffer = true })
      vim.keymap.set("t", "<C-h>", "<C-h>", { buffer = true })
      vim.keymap.set("t", "<C-l>", "<C-l>", { buffer = true })
    end,
  })
end

vim.filetype.add {
  filename = {
    ["Tiltfile"] = "tiltfile",
  },
}
