return {
  -- Bigram search motion
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  {
    "ggandor/flit.nvim",
    config = function()
      require('flit').setup()
    end,
  },
  -- Provide yank ring
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup()
      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
      vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
    end,
  },
  -- Show index of search results as virtual text
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
      local kopts = { silent = true }
      vim.keymap.set(
        "n",
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
      vim.keymap.set(
        "n",
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts
      )
    end,
  },
  -- Better * serach behavior
  {
    "haya14busa/vim-asterisk",
    after = "nvim-hlslens",
    config = function()
      vim.keymap.set({ "n", "x" }, "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.keymap.set({ "n", "x" }, "#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.keymap.set({ "n", "x" }, "g*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.keymap.set({ "n", "x" }, "g#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
    end,
  },
  -- Provide substitute operator
  {
    "gbprod/substitute.nvim",
    after = "yanky.nvim",
    config = function()
      require("substitute").setup {
        on_substitute = function(event)
          require("yanky").init_ring("p", event.register, event.count, event.vmode:match "[vV�]")
        end,
      }
      vim.keymap.set("x", "p", function()
        require("substitute").visual()
      end)
    end,
  },
  -- Expand <C-a> funcionality
  {
    "monaqa/dial.nvim",
    config = function()
      vim.keymap.set({ "n", "v" }, "<C-a>", require("dial.map").inc_normal())
      vim.keymap.set({ "n", "v" }, "<C-x>", require("dial.map").dec_normal())
      vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual())
      vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual())
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        preview = {
          win_height = 32,
        },
      }
    end,
  },
  -- fzf provides fuzzy search using fzf, used for integration with nvim-bqf
  { "junegunn/fzf" },
  -- lsp_signature provides popup window showing fucntion signatures
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup {
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
          border = "rounded",
        },
        hint_enable = true,
      }
    end,
  },
  {
    "Vonr/align.nvim",
    config = function()
      lvim.builtin.which_key.vmappings["A"] = {
        name = "+Align",
        a = {
          function()
            require("align").align_to_char(1, true)
          end,
          "Aligns to 1 character, looking left",
        },
        s = {
          function()
            require("align").align_to_char(2, true, true)
          end,
          "Aligns to 2 characters, looking left and with previews",
        },
        w = {
          function()
            require("align").align_to_string(false, true, true)
          end,
          "Aligns to a string, looking left and with previews",
        },
        r = {
          function()
            require("align").align_to_string(true, true, true)
          end,
          "Aligns to a Lua pattern, looking left and with previews",
        },
      }
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end
  },
  -- Distraction-free coding for Neovim
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {}
      lvim.builtin.which_key.mappings["Z"] = {
        function()
          require("zen-mode").toggle {}
        end,
        "Zen Mode",
      }
    end,
  },
  -- Dims inactive portions of the code you're editing
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
          "function",
          "method",
        },
      }
    end,
  },
  -- Replace via quickfix window
  {
    "gabrielpoca/replacer.nvim",
    config = function()
      vim.api.nvim_create_user_command("Replacer", function()
        require("replacer").run()
      end, {})
    end,
  },
  -- Better mark experience
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup()
    end,
  },
  {
    "github/copilot.vim",
  },
}
