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
          require("align").align_to_char({ length = 1 }, 1, true)
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
  -- Project-local configuration
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup()
    end,
    lazy = false,
  },
  -- Add key mappings to the default settings of mini.bufremov
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>C", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        ft_ignore = { "NvimTree", "packer", "dashboard", "help", "startify" },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          {
            sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScSa",
          },
          { text = { " ", builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          {
            sign = { namespace = { "gitsigns_extmark_signs_" }, colwidth = 1, auto = true, wrap = true },
            click = "v:lua.ScSa",
          },
          {
            sign = { name = { "Dap" }, colwidth = 1, auto = true, wrap = true },
            click = "v:lua.ScSa",
          },
          {
            sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
            click = "v:lua.ScSa",
          },
        },
      })
    end,
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
}
