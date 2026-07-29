-- [Lang] MoonBit language support with LSP and treesitter (local plugin).
return {
  "moonbit.nvim",
  dir = "~/ghq/github.com/choplin/moonbit.nvim",
  enabled = false, -- loaded by init.lua local plugin loader
  ft = { "moonbit" },
  after = function()
    require("moonbit").setup({
      mooncakes = {
        virtual_text = true,
        use_local = true,
      },
      treesitter = {
        enabled = true,
        auto_install = true,
      },
      lsp = {
        on_attach = function(client, bufnr) end,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      },
      jsonls = {
        settings = {},
      },
    })
  end,
}
