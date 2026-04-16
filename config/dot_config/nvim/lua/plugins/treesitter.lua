return {
  "nvim-treesitter",
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  deps = { { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", name = "nvim-treesitter-textobjects" } },
  version = "main",
  event = "User LazyFile",
  before = function()
    vim.cmd.packadd("nvim-treesitter-textobjects")
  end,
  after = function()
    -- Treesitter-based folding
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldlevel = 99

    -- Textobjects move keymaps
    local move = require("nvim-treesitter-textobjects.move")
    local map = vim.keymap.set
    local opts = { "n", "x", "o" }

    map(opts, "]f", function() move.goto_next_start("@function.outer") end, { desc = "Next function start" })
    map(opts, "]F", function() move.goto_next_end("@function.outer") end, { desc = "Next function end" })
    map(opts, "]c", function() move.goto_next_start("@class.outer") end, { desc = "Next class start" })
    map(opts, "]C", function() move.goto_next_end("@class.outer") end, { desc = "Next class end" })
    map(opts, "]a", function() move.goto_next_start("@parameter.inner") end, { desc = "Next parameter start" })
    map(opts, "]A", function() move.goto_next_end("@parameter.inner") end, { desc = "Next parameter end" })
    map(opts, "[f", function() move.goto_previous_start("@function.outer") end, { desc = "Previous function start" })
    map(opts, "[F", function() move.goto_previous_end("@function.outer") end, { desc = "Previous function end" })
    map(opts, "[c", function() move.goto_previous_start("@class.outer") end, { desc = "Previous class start" })
    map(opts, "[C", function() move.goto_previous_end("@class.outer") end, { desc = "Previous class end" })
    map(opts, "[a", function() move.goto_previous_start("@parameter.inner") end, { desc = "Previous parameter start" })
    map(opts, "[A", function() move.goto_previous_end("@parameter.inner") end, { desc = "Previous parameter end" })
  end,
}
