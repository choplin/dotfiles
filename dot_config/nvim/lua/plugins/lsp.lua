local local_env = require("local_env")
return {
  {
    "williamboman/mason.nvim",
    opts = {
      -- List linters and formatters to install here.
      -- LSP should be listed as opts.servers of nvim-lspconfig.
      ensure_installed = {
        -- linters
        "shellcheck",
        "ktlint",
        "hadolint",
        "ruff",
        -- formatters
        "stylua",
        "shfmt",
        "google-java-format",
      },
    },
  },
  -- Formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        java = { "google-java-format" },
        python = { "ruff_fix", "ruff_format" },
      },
    },
  },
  -- Linters
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        kotlin = { "ktlint" },
        dockerfile = { "hadolint" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", false }
      keys[#keys + 1] = { "<leader>cl", vim.lsp.codelens.run, mode = { "n" }, desc = "Code Lens" }
    end,
    ---@class PluginLspOpts
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
              schemas = {},
            },
          },
        },
        kotlin_language_server = {
          cmd_env = { JAVA_HOME = local_env.java and local_env.java.java_home_19 },
        },
        zls = {
          mason = false,
          cmd = { require("local_env").zls_path or "zls" },
        },
      },
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },
}
