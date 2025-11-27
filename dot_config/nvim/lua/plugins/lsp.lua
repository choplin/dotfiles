local local_env = require("local_env")
return {
  {
    "mason-org/mason.nvim",
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
    config = function()
      require("lint").linters.markdownlint.args = {
        "--disable",
        "MD013",
        "MD007",
        "--", -- Required
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    ---@class PluginLspOpts
    opts = function(_, opts)
      opts.servers = vim.tbl_extend("force", opts.servers or {}, {
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
        denols = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("deno.json", "deno.jsonc", "deps.ts")(fname)
          end,
          workspace_required = true,
        },
        ["*"] = {
          keys = {
            { "<c-k>", false, mode = "i" },
            { "<leader>cl", vim.lsp.codelens.run, mode = { "n" }, desc = "Code Lens" },
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
      })
      opts.codelens = {
        enabled = true,
      }
    end,
  },
}
