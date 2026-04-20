-- [Lang] Rust development tools with rust-analyzer integration.
--
--   <leader>cR         rust code action (on LspAttach)
--   <leader>dr         rust debuggables (on LspAttach)
return {
  "rustaceanvim",
  src = "https://github.com/mrcjkb/rustaceanvim",
  ft = { "rust" },
  after = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            checkOnSave = true,
            diagnostics = { enable = true },
            procMacro = { enable = true },
            files = {
              excludeDirs = { ".direnv", ".git", ".jj", "node_modules", "target" },
              watcher = "client",
            },
          },
        },
      },
    }
  end,
}
