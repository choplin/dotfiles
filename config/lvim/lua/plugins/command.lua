return {
  -- Provide commands for Ranger, command line filer
  {
    "kevinhwang91/rnvimr",
    config = function()
      vim.keymap.set({ "n", "t" }, "<M-o>", "<Cmd>RnvimrToggle<CR>", { silent = true })
      vim.keymap.set("t", "<M-i>", "<Cmd>RnvimrResize<CR>", { silent = true })
      vim.g.rnvimr_enable_ex = true
      vim.g.rnvimr_enable_picker = true
      vim.g.rnvimr_layout = {
        ["relative"] = "editor",
        ["width"] = vim.fn.float2nr(vim.fn.round(vim.o.columns * 0.9)),
        ["height"] = vim.fn.float2nr(vim.fn.round(vim.o.lines * 0.9)),
        ["col"] = vim.fn.float2nr(vim.fn.round(vim.o.columns * 0.05)),
        ["row"] = vim.fn.float2nr(vim.fn.round(vim.o.lines * 0.05)),
        ["style"] = "minimal",
      }
    end,
  },
  -- :SnipRun runs code instantly
  { "michaelb/sniprun", run = "bash ./install.sh", cmd = "SnipRun" },
  -- :Neogen generates documentation comments
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup { snippet_engine = "luasnip" }
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },
  -- :Trouble provides a pretty list of quickfix, diagnostics, telescopes etc.
  {
    "folke/trouble.nvim",
    after = "which-key.nvim",
    cmd = "Trouble",
    config = function()
      lvim.builtin.which_key.mappings["T"] = {
        name = "+Trouble",
        r = { "<cmd>Trouble lsp_references<cr>", "References" },
        f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
        d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
        q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
        l = { "<cmd>Trouble loclist<cr>", "LocationList" },
        w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
      }
    end,
  },
  -- Symbols Outline
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
      lvim.builtin.which_key.mappings["o"] = {
        function()
          require("symbols-outline").toggle_outline()
        end,
        "Symbols Outline",
      }
    end,
  },
  -- Note taking
  {
    "phaazon/mind.nvim",
    branch = "v2.2",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("mind").setup()
      lvim.builtin.which_key.mappings["m"] = {
        function()
          require("mind").open_project()
        end,
        "Mind Project",
      }
    end,
  },
}
