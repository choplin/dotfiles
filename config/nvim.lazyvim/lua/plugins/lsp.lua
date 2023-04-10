return {
  -- Override the default settings.
  -- Adapt externals tools to LSP
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {},
    },
  },
  -- Automatically setup null-ls for tolls installed via mason.nvim
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = {},
      automatic_installation = false,
      automatic_setup = true,
      handlers = {},
    },
  },
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
      "mfussenegger/nvim-jdtls",
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        rust_analyzer = {},
        jdtls = {},
        clangd = {},
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        rust_analyzer = function(_, opts)
          require("rust-tools").setup({
            server = opts,
            tools = {
              autoSetHints = true,
              -- hover_with_actions = true,
              inlay_hints = {
                show_parameter_hints = true,
              },
            },
          })
          return true
        end,
        jdtls = function()
          require("plugins.lsp.nvim-jdtls").setup()
          return true
        end,
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
