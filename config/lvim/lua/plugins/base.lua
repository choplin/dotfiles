return {
  -- Highlight Todo: comments
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  },
  -- Load a local .vimrc.lua file
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup {
        lookup_parents = true,
        config_files = { ".vimrc.lua" },
      }
    end,
  },
  -- Show scrollbar
  {
    "petertriho/nvim-scrollbar",
    after = { "nvim-hlslens" },
    config = function()
      local colors = require("tokyonight.colors").setup()
      require("scrollbar").setup {
        marks = {
          GitAdd = {
            text = { "▎" },
            color = colors.green,
            priority = 5,
          },
          GitDelete = {
            text = { "▎" },
            color = colors.red,
            priority = 5,
          },
          GitChange = {
            text = { "▎" },
            color = colors.blue,
            priority = 5,
          },
          GitChangeDelete = {
            text = { "▎" },
            color = colors.orange,
            priority = 5,
          },
          Error = { text = { "🮇" } },
          Info = { text = { "🮇" } },
          Warn = { text = { "🮇" } },
          Hint = { text = { "🮇" } },
          Search = {
            text = { "━" },
            priority = 6,
          },
        },
      }
      require("scrollbar.handlers.search").setup()
      vim.keymap.set("n", "<Esc>", function()
        require("scrollbar_ext").hide_search_results()
        vim.cmd "nohlsearch"
      end, {})
      require("scrollbar.handlers").register("git", function(bufnr)
        local gitsign = require "gitsigns"
        local gitsign_hunks = require "gitsigns.hunks"
        local colors_type = {
          add = "GitAdd",
          delete = "GitDelete",
          change = "GitChange",
          changedelete = "GitChangeDelete",
        }
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
    end,
  },
  -- Apply .editorconfig
  { "gpanders/editorconfig.nvim" },
  -- Expand .(repeat)/u(undo) funcionality to several plugins
  { "tpope/vim-repeat" },
  -- Provide UI that shows status of LSP at the bottom right
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },
  -- Provide Telescope ghq
  { "nvim-telescope/telescope-ghq.nvim" },
  -- Provide Telescope frecency
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      lvim.builtin.which_key.mappings["s"]["f"] = {
        function()
          require("telescope").extensions.frecency.frecency { workspace = "CWD" }
        end,
        "Frecency Current Directory",
      }
      lvim.builtin.which_key.mappings["sF"] = {
        function()
          require("telescope").extensions.frecency.frecency()
        end,
        "Frecency Global",
      }
    end,
    requires = { "kkharji/sqlite.lua" },
  },
  -- Provide Telescope symbols
  { "nvim-telescope/telescope-symbols.nvim" },
  -- Tracking coding activities
  { "wakatime/vim-wakatime" },
  -- Enable per-tab buffers
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
  },
}
