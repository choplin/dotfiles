require("lvim.lsp.manager").setup("yamlls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    require("lvim.lsp").common_on_attach(client, bufnr)
  end,
})
