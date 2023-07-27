local M = {}

local function config()
  local metals_config = require("metals").bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  }

  metals_config.init_options.statusBarProvider = "on"

  metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

  metals_config.on_attach = function(_, _)
    require("metals").setup_dap()
  end

  return metals_config
end

M.setup_dap = function()
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
end

M.setup_autocmd = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    callback = function()
      require("metals").initialize_or_attach(config())
    end,
  })
end

return M
