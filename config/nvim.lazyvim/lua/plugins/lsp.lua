return {
  -- Override the default settings.
  -- Adapt externals tools to LSP
  {
    "nvimtools/none-ls.nvim",
    opts = {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      enabled = false,
      sources = {},
    },
  },
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
        "prettierd",
      },
    },
  },
  -- Formatters
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>uf",
        function()
          if vim.g.disable_autoformat then
            vim.g.disable_autoformat = false
            vim.notify("Enabled format on save", vim.log.levels.INFO, { title = "Format" })
          else
            vim.g.disable_autoformat = true
            vim.notify("Disabled format on save", vim.log.levels.WARN, { title = "Format" })
          end
        end,
        "n",
        desc = "Toggle format on Save with conform",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,

      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        java = { "google-java-format" },
        python = { "ruff_fix", "ruff_format" },
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        vue = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        less = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
        handlebars = { { "prettierd", "prettier" } },
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
      -- use auto formatting with conform.nvim if available
      autoformat = not require("lazyvim.util").has("conform.nvim"),
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
          mason = true,
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
