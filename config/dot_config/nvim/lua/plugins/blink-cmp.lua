return {
  "blink.cmp",
  src = "https://github.com/saghen/blink.cmp",
  version = vim.version.range("1.*"),
  deps = {
    { src = "https://github.com/rafamadriz/friendly-snippets", name = "friendly-snippets" },
    { src = "https://github.com/mikavilpas/blink-ripgrep.nvim", name = "blink-ripgrep.nvim" },
  },
  event = { "InsertEnter", "CmdlineEnter" },
  before = function()
    vim.cmd.packadd("friendly-snippets")
    vim.cmd.packadd("blink-ripgrep.nvim")
  end,
  after = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            opts = {
              search_casing = "--smart-case",
            },
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.labelDetails = { description = "(rg)" }
              end
              return items
            end,
          },
        },
      },
      completion = {
        list = {
          selection = {
            auto_insert = true,
            preselect = false,
          },
        },
        ghost_text = { enabled = false },
        menu = { auto_show = true },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
        completion = {
          list = {
            selection = {
              auto_insert = true,
              preselect = false,
            },
          },
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },
    })

    -- Completion toggle
    vim.g.completion = true
    Snacks.toggle({
      name = "Completion",
      get = function()
        return vim.g.completion
      end,
      set = function(state)
        vim.g.completion = state
      end,
    }):map("<leader>uk")
  end,
}
