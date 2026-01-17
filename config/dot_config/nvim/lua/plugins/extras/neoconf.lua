-- neoconf.nvim - Local configuration for LSP servers

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
      },
    },
  },
}
