return {
  "nvim-lspconfig",
  src = "https://github.com/neovim/nvim-lspconfig",
  deps = {
    { src = "https://github.com/mason-org/mason.nvim", name = "mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim", name = "mason-lspconfig.nvim" },
  },
  event = "User LazyFile",
  before = function()
    vim.cmd.packadd("mason.nvim")
    vim.cmd.packadd("mason-lspconfig.nvim")
  end,
  after = function()
    -- Mason setup (must come before mason-lspconfig)
    require("mason").setup({ PATH = "append" })
    require("mason-lspconfig").setup({ automatic_enable = true })

    -- Diagnostics
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
    })

    -- lua_ls configuration
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          completion = { callSnippet = "Replace" },
          doc = { privateName = { "^_" } },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    -- LspAttach autocmd for keymaps, inlay hints, and codelens
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_config", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        local map = function(lhs, rhs, desc, mode)
          vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Navigation
        map("gd", vim.lsp.buf.definition, "Goto Definition")
        map("gr", vim.lsp.buf.references, "References")
        map("gI", vim.lsp.buf.implementation, "Goto Implementation")
        map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")

        -- Info
        map("K", vim.lsp.buf.hover, "Hover")
        map("gK", vim.lsp.buf.signature_help, "Signature Help")
        map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")

        -- Actions
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
        map("<leader>cr", vim.lsp.buf.rename, "Rename")
        map("<leader>cl", vim.lsp.codelens.run, "Run Codelens", { "n", "v" })

        -- Inlay hints
        if client:supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end

        -- Codelens
        if client:supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh({ bufnr = buf })
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buf,
            callback = function()
              vim.lsp.codelens.refresh({ bufnr = buf })
            end,
          })
        end
      end,
    })
  end,
}
