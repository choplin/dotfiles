-- [Lang] Java LSP via Eclipse JDTLS with project detection.
return {
  "nvim-jdtls",
  src = "https://github.com/mfussenegger/nvim-jdtls",
  ft = { "java" },
  after = function()
    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)
      local root_dir = vim.fs.root(fname, {
        "build.gradle", "build.gradle.kts", "build.xml",
        "pom.xml", "settings.gradle", "settings.gradle.kts",
      })

      local cmd = { vim.fn.exepath("jdtls") }
      local project_name = root_dir and vim.fs.basename(root_dir) or "default"
      local config_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
      local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"

      vim.list_extend(cmd, { "-configuration", config_dir, "-data", workspace_dir })

      local config = {
        cmd = cmd,
        root_dir = root_dir,
        settings = {
          java = {
            inlayHints = { parameterNames = { enabled = "all" } },
          },
        },
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      }

      require("jdtls").start_or_attach(config)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = attach_jdtls,
    })

    attach_jdtls()
  end,
}
