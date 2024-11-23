return {
  -- Markdown table
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    config = function()
      -- vim.g.table_mode_disable_mappings = true
      -- vim.g.table_mode_always_active = true
    end,
  },
  -- Zig
  {
    "ziglang/zig.vim",
    ft = "zig",
    config = function()
      vim.g.zig_fmt_autosave = 0
    end,
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
