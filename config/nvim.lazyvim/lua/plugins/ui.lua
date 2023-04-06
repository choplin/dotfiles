return {
  -- Prompt to pick a window
  {
    "s1n7ax/nvim-window-picker",
    main = "window-picker",
  },
  -- Enable per-tab buffers
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
  },
  -- Show scrollbar
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
    },
    event = { "BufWinEnter" },
    config = function()
      local colors = require("tokyonight.colors").setup()
      require("scrollbar").setup({
        marks = {
          GitAdd = { text = { "▎" }, color = colors.green, priority = 5 },
          GitDelete = { text = { "▎" }, color = colors.red, priority = 5 },
          GitChange = { text = { "▎" }, color = colors.blue, priority = 5 },
          GitChangeDelete = { text = { "▎" }, color = colors.orange, priority = 5 },
          Error = { text = { "🮇" } },
          Info = { text = { "🮇" } },
          Warn = { text = { "🮇" } },
          Hint = { text = { "🮇" } },
          Search = { text = { "━" }, priority = 6 },
        },
        handlers = { search = true },
      })
      do
        local gitsign = require("gitsigns")
        local gitsign_hunks = require("gitsigns.hunks")
        local colors_type = {
          add = "GitAdd",
          delete = "GitDelete",
          change = "GitChange",
          changedelete = "GitChangeDelete",
        }
        require("scrollbar.handlers").register("git", function(bufnr)
          local nb_lines = vim.api.nvim_buf_line_count(bufnr)
          local lines = {}
          local hunks = gitsign.get_hunks(bufnr)
          if hunks then
            for _, hunk in ipairs(hunks) do
              hunk.vend = math.min(hunk.added.start, hunk.removed.start) + hunk.added.count + hunk.removed.count
              local signs = gitsign_hunks.calc_signs(hunk, 0, nb_lines)
              for _, sign in ipairs(signs) do
                table.insert(lines, {
                  line = sign.lnum,
                  type = colors_type[sign.type],
                })
              end
            end
          end
          return lines
        end)
      end
    end,
  },
}
