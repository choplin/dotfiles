-- [LSP] LSP client configuration. Binaries come from the editor PATH (Nix), not Mason.
--
--   gd                 definition
--   gr                 references
--   gI                 implementation
--   K                  hover
--   <leader>ca         code action
--   <leader>cr         rename
--   <leader>cl         codelens
--   Tab                accept Copilot suggestion (insert)
--   M-] / M-[          next / prev Copilot suggestion
local function safe_require(modname)
  local ok, mod = pcall(require, modname)
  return ok and mod or {}
end

return {
  "nvim-lspconfig",
  src = "https://github.com/neovim/nvim-lspconfig",
  deps = {
    { src = "https://github.com/b0o/SchemaStore.nvim", name = "SchemaStore.nvim" },
  },
  event = "User LazyFile",
  before = function()
    vim.cmd.packadd("SchemaStore.nvim")
  end,
  after = function()
    local local_env = safe_require("local_env")

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

    -- jsonls with SchemaStore
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          format = { enable = true },
          validate = { enable = true },
          schemas = require("schemastore").json.schemas(),
        },
      },
    })
    vim.lsp.enable("jsonls")

    -- zls
    vim.lsp.config("zls", {
      cmd = { local_env.zls_path or "zls" },
    })
    vim.lsp.enable("zls")

    -- denols (project-local Deno; only when `deno` is on PATH)
    vim.lsp.config("denols", {
      root_markers = { "deno.json", "deno.jsonc", "deps.ts" },
      workspace_required = true,
    })
    if vim.fn.executable("deno") == 1 then
      vim.lsp.enable("denols")
    end

    -- nil_ls (Nix) — replaced by nixd in a follow-up language-tooling change
    vim.lsp.config("nil_ls", {
      settings = {
        ["nil"] = {
          formatting = { command = { "alejandra" } },
        },
      },
    })
    vim.lsp.enable("nil_ls")

    -- Project-local JS/TS/Python tooling: enable only when the binary is visible.
    -- These are not in the common editor PATH catalog; use a project devShell + direnv.
    -- Treesitter parsers for these languages still ship in the Neovim Nix closure.
    if vim.fn.executable("biome") == 1 then
      vim.lsp.enable("biome")
    end
    if vim.fn.executable("vtsls") == 1 then
      vim.lsp.enable("vtsls")
    end
    if vim.fn.executable("pyright") == 1 then
      vim.lsp.enable("pyright")
    end
    if vim.fn.executable("ruff") == 1 then
      vim.lsp.enable("ruff")
    end

    -- gopls (Go)
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    })
    vim.lsp.enable("gopls")

    -- yamlls with SchemaStore
    vim.lsp.config("yamlls", {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      before_init = function(_, config)
        config.settings.yaml.schemas = vim.tbl_deep_extend(
          "force",
          config.settings.yaml.schemas or {},
          require("schemastore").yaml.schemas()
        )
      end,
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          keyOrdering = false,
          format = { enable = true },
          validate = true,
          schemaStore = { enable = false, url = "" },
        },
      },
    })
    vim.lsp.enable("yamlls")

    -- taplo (TOML)
    vim.lsp.enable("taplo")

    -- dockerls + docker-compose
    vim.lsp.enable("dockerls")
    vim.lsp.enable("docker_compose_language_service")

    -- tailwindcss
    vim.lsp.config("tailwindcss", {
      settings = {
        tailwindCSS = {
          includeLanguages = {
            elixir = "html-eex",
            eelixir = "html-eex",
            heex = "html-eex",
          },
        },
      },
    })
    vim.lsp.enable("tailwindcss")

    -- svelte
    vim.lsp.enable("svelte")

    -- marksman (Markdown)
    vim.lsp.enable("marksman")

    -- clangd (C/C++)
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      capabilities = { offsetEncoding = { "utf-16" } },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    })
    vim.lsp.enable("clangd")

    -- Copilot (native LSP, Neovim 0.12+)
    if vim.fn.has("nvim-0.12") == 1 then
      vim.lsp.config("copilot", {
        handlers = {
          didChangeStatus = function(err, res)
            if not err and res.status == "Error" then
              vim.notify("Please use :LspCopilotSignIn to sign in to Copilot", vim.log.levels.ERROR)
            end
          end,
        },
      })
      vim.lsp.enable("copilot")
      vim.schedule(function()
        vim.lsp.inline_completion.enable()
      end)
      vim.keymap.set({ "i", "n" }, "<M-]>", function()
        vim.lsp.inline_completion.select({ count = 1 })
      end, { desc = "Next Copilot Suggestion" })
      vim.keymap.set({ "i", "n" }, "<M-[>", function()
        vim.lsp.inline_completion.select({ count = -1 })
      end, { desc = "Prev Copilot Suggestion" })
      vim.keymap.set("i", "<Tab>", function()
        if not vim.lsp.inline_completion.get() then
          return "<Tab>"
        end
      end, { expr = true, desc = "Accept Copilot Suggestion" })
    end

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
          vim.lsp.codelens.enable(true, { bufnr = buf })
        end
      end,
    })
  end,
}
