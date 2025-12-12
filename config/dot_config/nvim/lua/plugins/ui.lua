return {
  -- Enable per-tab buffers
  {
    "tiagovla/scope.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
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
    "folke/snacks.nvim",
    opts = function(_, opts)
      local function is_diffview_buf(buf)
        local ft = vim.bo[buf].filetype
        return ft == "DiffviewFiles" or ft == "DiffviewFilePanel" or ft == "DiffviewFileHistoryPanel"
      end
      opts.indent.filter = function(buf)
        return vim.g.snacks_indent ~= false
          and vim.b[buf].snacks_indent ~= false
          and vim.bo[buf].buftype == ""
          and not is_diffview_buf(buf)
      end
      opts.scope.filter = function(buf)
        return vim.bo[buf].buftype == ""
          and vim.b[buf].snacks_scope ~= false
          and vim.g.snacks_scope ~= false
          and not is_diffview_buf(buf)
      end
    end,
  },
}
