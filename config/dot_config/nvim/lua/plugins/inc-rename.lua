return {
  "inc-rename.nvim",
  src = "https://github.com/smjonas/inc-rename.nvim",
  cmd = "IncRename",
  after = function()
    require("inc_rename").setup({})

    -- Override <leader>cr to use inc-rename
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("inc_rename_attach", { clear = true }),
      callback = function(args)
        vim.keymap.set("n", "<leader>cr", function()
          return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end, { buffer = args.buf, expr = true, desc = "Rename (inc-rename)" })
      end,
    })
  end,
}
