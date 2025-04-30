return {
  -- :SnipRun runs code instantly
  { "michaelb/sniprun", build = "bash ./install.sh", cmd = "SnipRun" },
  -- Provide :Linediff to compare the selection areas
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
  },
  -- Provide a fancy UI for json
  {
    "gennaro-tedesco/nvim-jqx",
    cmd = { "JqxList", "JqxQuery" },
  },
  -- Align text
  {
    "Vonr/align.nvim",
    init = function()
      local ok, wk = pcall(require, "which-key")
      if ok then
        wk.add({ "<leader>A", group = "Align", mode = "x" })
      end
    end,
    keys = {
      {
        "<leader>Aa",
        function()
          require("align").align_to_char({ length = 1, reverse = true })
        end,
        mode = { "x" },
        desc = "Aligns to 1 character, looking left",
      },
      {
        "<leader>As",
        function()
          require("align").align_to_char({ length = 2, reverse = true, preview = true })
        end,
        mode = { "x" },
        desc = "Aligns to 2 characters, looking left and with previews",
      },
      {
        "<leader>Aw",
        function()
          require("align").align_to_string({ regex = false, reverse = true, preview = true })
        end,
        mode = { "x" },
        desc = "Aligns to a string, looking left and with previews",
      },
      {
        "<leader>Ar",
        function()
          require("align").align_to_string({ regex = true, reverse = true, preview = true })
        end,
        mode = { "x" },
        desc = "Aligns to a Lua pattern, looking left and with previews",
      },
    },
  },
  -- Better mark experience
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Project-local configuration
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup()
    end,
    lazy = false,
  },
  -- Make Neovim's fold look modern and keep high performance
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {},
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        mode = { "n" },
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        mode = { "n" },
        desc = "Close all folds",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
        winbar = true,
      },
      filesystem = {
        group_empty_dirs = true,
      },
    },
  },
}
