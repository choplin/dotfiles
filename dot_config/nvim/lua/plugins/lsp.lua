return {
  {
    "williamboman/mason.nvim",
    opts = {
      -- List linters and formatters to install here.
      -- LSP should be listed as opts.servers of nvim-lspconfig.
      ensure_installed = {
        -- linters
        "luacheck",
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
        lua = { "luacheck" },
        sh = { "shellcheck" },
        kotlin = { "ktlint" },
        dockerfile = { "hadolint" },
      },
    },
  },
  -- Better suppor for editing init.lua and plugin development
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
      "b0o/SchemaStore.nvim",
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", false }
      keys[#keys + 1] = { "<leader>cl", vim.lsp.codelens.run, mode = { "n" }, desc = "Code Lens" }
    end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(
              new_config.settings.json.schemas,
              require("schemastore").json.schemas({
                ignore = {
                  "Red-DiscordBot Cog",
                  "Red-DiscordBot Cog Repo",
                },
                extra = {
                  {
                    name = "QMK configuration",
                    fileMatch = { "info.json" },
                    folderUri = vim.loop.os_homedir() .. "/qmk",
                    url = vim.uri_from_fname(
                      vim.loop.os_homedir() .. "/qmk/qmk_firmware/data/schemas/keyboard.jsonschema"
                    ),
                  },
                },
              })
            )
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
              schemas = {},
            },
          },
        },
        kotlin_language_server = {
          cmd_env = { JAVA_HOME = require("local_env").java.java_home_19 },
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
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
