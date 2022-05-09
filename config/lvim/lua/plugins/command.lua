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
        ['relative'] = 'editor',
        ['width'] = vim.fn.float2nr(vim.fn.round(vim.o.columns * 0.9)),
        ['height'] = vim.fn.float2nr(vim.fn.round(vim.o.lines * 0.9)),
        ['col'] = vim.fn.float2nr(vim.fn.round(vim.o.columns * 0.05)),
        ['row'] = vim.fn.float2nr(vim.fn.round(vim.o.lines * 0.05)),
        ['style'] = 'minimal'
      }
    end
  },
  -- :Aerial*  provides code outline sidebar
  {
    "stevearc/aerial.nvim",
    config = function() require("aerial").setup {
        on_attach = function(bufnr)
          -- Toggle the aerial window with <leader>a
          vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
          -- Jump forwards/backwards with "{" and "}"
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end
      }
    end
  },
  -- :SnipRun runs code instantly
  { "michaelb/sniprun", run = "bash ./install.sh", cmd = "SnipRun" },
  -- :Neogen generates documentation comments
  {
    "danymat/neogen",
    config = function()
      require("neogen").setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },
  -- :Ultest* runs tests with fancy UI
  { "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins" },
  -- :Trouble provides a pretty list of quickfix, diagnostics, telescopes etc.
  {
    "folke/trouble.nvim",
    after = "which-key.nvim",
    cmd = "Trouble",
    config = function()
      require("which-key").register({
        ["<leader>t"] = {
          name = "+Trouble",
          r = { "<cmd>Trouble lsp_references<cr>", "References" },
          f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
          d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
          q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
          l = { "<cmd>Trouble loclist<cr>", "LocationList" },
          w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
        }
      })

      local trouble = require("trouble.providers.telescope")
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
    end

  },
  -- Spectre provides regexp search and replace
  {
    "windwp/nvim-spectre", event = "BufRead", config = function()
      vim.keymap.set("n", "<leader>S", function() require("spectre").open_file_search() end)
    end
  },
}
