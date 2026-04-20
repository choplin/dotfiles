-- [Misc] Keybinding discovery popup with group labels.
--
--   <leader>?          buffer keymaps
--   C-w <space>        window hydra mode
return {
  "which-key.nvim",
  src = "https://github.com/folke/which-key.nvim",
  event = "DeferredUIEnter",
  after = function()
    local wk = require("which-key")
    wk.setup({
      preset = "helix",
      spec = {
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>dp", group = "profiler" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        { "gx", desc = "Open with system app" },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>?", function()
      wk.show({ global = false })
    end, { desc = "Buffer Keymaps (which-key)" })
    vim.keymap.set("n", "<c-w><space>", function()
      wk.show({ keys = "<c-w>", loop = true })
    end, { desc = "Window Hydra Mode (which-key)" })
  end,
}
