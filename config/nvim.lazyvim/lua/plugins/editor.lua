return {
  -- :SnipRun runs code instantly
  { "michaelb/sniprun", build = "bash ./install.sh", cmd = "SnipRun" },
  -- :Neogen generates documentation comments
  {
    "danymat/neogen",
    cmd = "Neogen",
    opts = { snippet_engine = "luasnip" },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  -- Aerial to display symbol outline
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      {
        "<leader>co",
        function()
          require("aerial").toggle()
        end,
        desc = "Symbols Outline",
      },
    },
    opts = {
      show_guides = true,
    },
  },
  -- Task Runner
  {
    "stevearc/overseer.nvim",
    cmd = "OverseerRun",
    opts = {
      templates = { "builtin" },
    },
  },
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
        wk.register({
          mode = { "x" },
          ["<leader>A"] = { name = "+Align" },
        })
      end
    end,
    keys = {
      {
        "<leader>Aa",
        function()
          require("align").align_to_char(1, true)
        end,
        mode = { "x" },
        desc = "Aligns to 1 character, looking left",
      },
      {
        "<leader>As",
        function()
          require("align").align_to_char(2, true, true)
        end,
        mode = { "x" },
        desc = "Aligns to 2 characters, looking left and with previews",
      },
      {
        "<leader>Aw",
        function()
          require("align").align_to_string(false, true, true)
        end,
        mode = { "x" },
        desc = "Aligns to a string, looking left and with previews",
      },
      {
        "<leader>Ar",
        function()
          require("align").align_to_string(true, true, true)
        end,
        mode = { "x" },
        desc = "Aligns to a Lua pattern, looking left and with previews",
      },
    },
  },
  -- Distraction-free coding for Neovim
  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<space>Z",
        function()
          require("zen-mode").toggle({})
        end,
        desc = "Zen Mode",
      },
    },
  },
  -- Dims inactive portions of the code you're editing
  {
    "folke/twilight.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
        "function",
        "method",
      },
    },
  },
  -- Better mark experience
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
