return {
  -- Prompt to pick a window
  {
    "s1n7ax/nvim-window-picker",
    main = "window-picker",
    event = { "BufReadPost", "BufNewFile" },
  },
  -- Enable per-tab buffers
  {
    "tiagovla/scope.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Show scrollbar
  -- {
  --   "petertriho/nvim-scrollbar",
  --   dependencies = {
  --     "lewis6991/gitsigns.nvim",
  --     "kevinhwang91/nvim-hlslens",
  --   },
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     local palette = require("palette").palette
  --     require("scrollbar").setup({
  --       marks = {
  --         GitAdd = { text = { "▎" }, color = palette.green, priority = 5 },
  --         GitDelete = { text = { "▎" }, color = palette.red, priority = 5 },
  --         GitChange = { text = { "▎" }, color = palette.blue, priority = 5 },
  --         GitChangeDelete = { text = { "▎" }, color = palette.orange, priority = 5 },
  --         Error = { text = { "🮇" } },
  --         Info = { text = { "🮇" } },
  --         Warn = { text = { "🮇" } },
  --         Hint = { text = { "🮇" } },
  --         Search = { text = { "━" }, priority = 6 },
  --       },
  --       handlers = { search = true },
  --     })
  --     do
  --       local gitsign = require("gitsigns")
  --       local gitsign_hunks = require("gitsigns.hunks")
  --       local colors_type = {
  --         add = "GitAdd",
  --         delete = "GitDelete",
  --         change = "GitChange",
  --         changedelete = "GitChangeDelete",
  --       }
  --       require("scrollbar.handlers").register("git", function(bufnr)
  --         local nb_lines = vim.api.nvim_buf_line_count(bufnr)
  --         local lines = {}
  --         local hunks = gitsign.get_hunks(bufnr)
  --         if hunks then
  --           for _, hunk in ipairs(hunks) do
  --             hunk.vend = math.min(hunk.added.start, hunk.removed.start) + hunk.added.count + hunk.removed.count
  --             local signs = gitsign_hunks.calc_signs(hunk, 0, nb_lines)
  --             for _, sign in ipairs(signs) do
  --               table.insert(lines, {
  --                 line = sign.lnum,
  --                 type = colors_type[sign.type],
  --               })
  --             end
  --           end
  --         end
  --         return lines
  --       end)
  --     end
  --   end,
  -- },
  -- Better Quickfix UI
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      "junegunn/fzf",
      "gabrielpoca/replacer.nvim",
    },
    opts = {
      preview = {
        win_height = 32,
      },
    },
  },
  -- Replace via quickfix window
  {
    "gabrielpoca/replacer.nvim",
    lazy = true,
    init = function()
      vim.api.nvim_create_user_command("Replacer", function()
        require("replacer").run()
      end, {})
    end,
  },
  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    opts = {
      indent = {
        highlight = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        char = "",
      },
      whitespace = {
        highlight = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        remove_blankline_trail = false,
      },
    },
    config = function(_, opts)
      local palette = require("palette").palette
      vim.cmd.highlight("IndentBlanklineIndent1", "guibg=" .. palette.bg, "gui=nocombine")
      vim.cmd.highlight("IndentBlanklineIndent2", "guibg=" .. palette.bg_dark, "gui=nocombine")
      require("ibl").setup(opts)
    end,
  },
}
