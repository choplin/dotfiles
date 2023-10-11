return {
  -- Provide markdown preview in browser
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", ft = "markdown" },
  -- Markdown table
  { "dhruvasagar/vim-table-mode", ft = "markdown" },
  -- Zig
  {
    "ziglang/zig.vim",
    ft = "zig",
    config = function()
      vim.g.zig_fmt_autosave = 0
    end,
  },
  -- Scala
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt" },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require("plugins.lsp.nvim-metals").setup_autocmd()
    end,
    config = function()
      require("plugins.lsp.nvim-metals").setup_dap()
    end,
  },
  -- python
  {
    "linux-cultist/venv-selector.nvim",
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = { "python" } } },
  },
  -- Java
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local local_env = require("local_env")
      local lombok_jar_path = vim.fn.stdpath("config") .. "/jdtls/lombok.jar"
      if vim.fn.filereadable(lombok_jar_path) then
        opts.cmd = {
          "jdtls",
          "--jvm-arg=-javaagent:" .. lombok_jar_path,
          "--jvm-arg=-Xbootclasspath/a:" .. lombok_jar_path,
        }
      end
      local settings = require("plugins.lsp.nvim-jdtls").settings()

      opts.jdtls = {
        cmd_env = {
          JAVA_HOME = local_env.java.java_home_17,
        },
        capabilities = {
          workspace = {
            configuration = true,
          },
        },
        on_init = function(client, _)
          client.notify("workspace/didChangeConfiguration", { settings = settings })
        end,
        settings = settings,
      }
    end,
  },
}
