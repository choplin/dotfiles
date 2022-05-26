require("lvim.lsp.manager").setup("jsonls", {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    require("lvim.lsp").common_on_attach(client, bufnr)
  end,
})
