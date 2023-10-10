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
        "ktlint",
        "hadolint",
        -- formatters
        "stylua",
        "shfmt",
        "google-java-format",
        "black",
        "isort",
        "prettierd",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },

      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        java = { "google-java-format" },
        python = { "black", "isort" },
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
      "b0o/schemastore.nvim",
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", false }
    end,
    ---@class PluginLspOpts
    opts = {
      autoformat = false,
      ---@type lspconfig.options
      servers = {
        rust_analyzer = {},
        jdtls = {},
        clangd = {},
        gopls = {},
        jsonls = {},
        yamlls = {},
        lua_ls = {},
        pyright = {},
        tsserver = {},
        kotlin_language_server = {
          cmd_env = { JAVA_HOME = require("local_env").java.java_home_19 },
        },
        zls = {
          mason = true,
          --cmd = { vim.loop.os_homedir() .. "/ghq/github.com/zigtools/zls/zig-out/bin/zls" },
        },
        java_language_server = {
          mason = false,
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
          -- Set jdtls in ftplugin to enable it only for java files
          return true
        end,
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
        java_language_server = function()
          return true
        end,
        jsonls = function(_, opts)
          opts.settings = {
            json = {
              schemas = require("schemastore").json.schemas({
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
              }),
              validate = { enable = true },
            },
          }
        end,
        yamlls = function(_, opts)
          opts.settings = {
            yaml = {
              schemaStore = {
                enable = false, -- disable build-in schemaStore support
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          }
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
