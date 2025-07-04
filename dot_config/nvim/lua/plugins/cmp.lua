return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        list = {
          selection = {
            auto_insert = true,
            preselect = false,
          },
        },
        ghost_text = {
          enabled = false,
        },
        menu = {
          auto_show = true,
        },
      },
      keymap = {
        preset = "default",
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          --["<CR>"] = { "select_accept_and_enter", "fallback" },
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
          menu = {
            auto_show = true,
          },
          ghost_text = {
            enabled = true,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "mikavilpas/blink-ripgrep.nvim",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "ripgrep" },
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {
              search_casing = "--smart-case",
            },
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.labelDetails = {
                  description = "(rg)",
                }
              end
              return items
            end,
          },
        },
      },
    },
  },
}
