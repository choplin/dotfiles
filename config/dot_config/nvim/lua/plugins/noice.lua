-- [UI] Enhanced UI for messages, command line, and popups.
--
--   <leader>snl        last message
--   <leader>snh        message history
--   <leader>snd        dismiss notifications
--   S-Enter            redirect cmdline
return {
  "noice.nvim",
  src = "https://github.com/folke/noice.nvim",
  deps = { { src = "https://github.com/MunifTanjim/nui.nvim", name = "nui.nvim" } },
  event = "DeferredUIEnter",
  before = function()
    vim.cmd.packadd("nui.nvim")
  end,
  after = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    })

    -- Keymaps
    local map = vim.keymap.set
    map("c", "<S-Enter>", function()
      require("noice").redirect(vim.fn.getcmdline())
    end, { desc = "Redirect Cmdline" })
    map("n", "<leader>snl", function()
      require("noice").cmd("last")
    end, { desc = "Noice Last Message" })
    map("n", "<leader>snh", function()
      require("noice").cmd("history")
    end, { desc = "Noice History" })
    map("n", "<leader>sna", function()
      require("noice").cmd("all")
    end, { desc = "Noice All" })
    map("n", "<leader>snd", function()
      require("noice").cmd("dismiss")
    end, { desc = "Dismiss All" })
    map({ "i", "n", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end, { silent = true, expr = true, desc = "Scroll Forward" })
    map({ "i", "n", "s" }, "<c-b>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
      end
    end, { silent = true, expr = true, desc = "Scroll Backward" })
  end,
}
