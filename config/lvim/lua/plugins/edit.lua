return {
  -- general-purpose motion plugin
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
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
      vim.keymap.set("x", "s", function()
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
  -- Make marker management easy
  -- { "chentau/marks.nvim", config = function() require 'marks'.setup {} end },
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
        hint_enable = false,
      }
    end,
  },
  {
    "Vonr/align.nvim",
    config = function()
      require("which-key").register({
        ["A"] = {
          name = "+Aligh",
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
        },
      }, { prefix = "<leader>", mode = "x" })
    end,
  },
  { "tpope/vim-surround" },
}
