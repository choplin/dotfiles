return {
  -- Provide markdown preview in browser
  { "iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = "markdown" },
  -- Markdown table
  { "dhruvasagar/vim-table-mode", ft = "markdown" },
  --Rust
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      if require("mason-registry").is_installed "rust-analyzer" then
        local default_opts = require("lvim.lsp").get_common_opts()
        local package_dir = require("mason-core.path").package_prefix "rust-analyzer"

        require("rust-tools").setup {
          server = vim.tbl_deep_extend("force", default_opts, {
            cmd_env = { PATH = require("mason-core.process").extend_path { package_dir } },
          }),
          tools = {
            autoSetHints = true,
            -- hover_with_actions = true,
            inlay_hints = {
              show_parameter_hints = true,
            },
          },
        }
      end
    end,
  },
  -- Ron (Rusty Object Notation)
  { "ron-rs/ron.vim" },
  -- Starlark (Tiltfile)
  { "cappyzawa/starlark.vim", ft = "starlark" },
  -- Flutter
  {
    "akinsho/flutter-tools.nvim",
    requires = "nvim-lua/plenary.nvim",
    ft = "dart",
    config = function()
      require("flutter-tools").setup {}
    end,
  },
  -- Scala
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      metals_config.init_options.statusBarProvider = "on"
      table.insert(lvim.builtin.lualine.sections.lualine_c, "g:metals_status")
      require("lvim.core.lualine").setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
      require("dap").configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "RunOrTest",
          metals = {
            runType = "runOrTestFile",
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Test Target",
          metals = {
            runType = "testTarget",
          },
        },
      }

      metals_config.on_attach = function(_, _)
        require("metals").setup_dap()
      end

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  -- Helm
  { "towolf/vim-helm" },
  -- Zig
  { "ziglang/zig.vim" },
}
