-- [Treesitter] Treesitter syntax highlighting, text objects, and folding.
--
--   ]f / [f            next/prev function
--   ]c / [c            next/prev class
--   ]a / [a            next/prev parameter
return {
  "nvim-treesitter",
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  deps = { { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", name = "nvim-treesitter-textobjects" } },
  version = "main",
  event = "FileType",
  keys = {
    { "]f", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer") end, mode = { "n", "x", "o" }, desc = "Next function start" },
    { "]F", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer") end, mode = { "n", "x", "o" }, desc = "Next function end" },
    { "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer") end, mode = { "n", "x", "o" }, desc = "Next class start" },
    { "]C", function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer") end, mode = { "n", "x", "o" }, desc = "Next class end" },
    { "]a", function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner") end, mode = { "n", "x", "o" }, desc = "Next parameter start" },
    { "]A", function() require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.inner") end, mode = { "n", "x", "o" }, desc = "Next parameter end" },
    { "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer") end, mode = { "n", "x", "o" }, desc = "Previous function start" },
    { "[F", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer") end, mode = { "n", "x", "o" }, desc = "Previous function end" },
    { "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer") end, mode = { "n", "x", "o" }, desc = "Previous class start" },
    { "[C", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer") end, mode = { "n", "x", "o" }, desc = "Previous class end" },
    { "[a", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner") end, mode = { "n", "x", "o" }, desc = "Previous parameter start" },
    { "[A", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.inner") end, mode = { "n", "x", "o" }, desc = "Previous parameter end" },
  },
  before = function()
    vim.cmd.packadd("nvim-treesitter-textobjects")
  end,
  after = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        if ft == "" then
          return
        end
        local lang = vim.treesitter.language.get_lang(ft)
        if lang and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0 then
          pcall(vim.treesitter.start, ev.buf)
        end
      end,
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldlevel = 99
  end,
}
