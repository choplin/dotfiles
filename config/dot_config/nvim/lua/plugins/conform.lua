-- [LSP] Code formatter with per-language formatter configuration and format-on-save.
--
--   <leader>cf         format (Conform + LSP fallback)
--   <leader>cF         format injected langs
--   (auto-formats on BufWritePre)
return {
  "conform.nvim",
  src = "https://github.com/stevearc/conform.nvim",
  event = "User LazyFile",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  after = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        nix = { "alejandra" },
        markdown = { "markdownlint-cli2" },
        md = { "markdownlint-cli2" },
        python = { "ruff_fix", "ruff_format" },
        javascript = { "biome-check" },
        javascriptreact = { "biome-check" },
        typescript = { "biome-check" },
        typescriptreact = { "biome-check" },
        json = { "biome-check" },
        jsonc = { "biome-check" },
        css = { "biome-check" },
        svelte = { "biome-check" },
        graphql = { "biome-check" },
        go = { "goimports", "gofumpt" },
        toml = { "taplo" },
      },
      formatters = {
        ["biome-check"] = { require_cwd = true },
        -- Project-local only: skip quietly when the tool / cwd marker is absent.
        ruff_format = { require_cwd = true },
        ruff_fix = { require_cwd = true },
      },
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      -- Missing formatters must not abort :write.
      notify_on_error = true,
      notify_no_formatters = false,
    })

    -- Auto-format on save (respects vim.g.autoformat and vim.b.autoformat).
    -- Runs on BufWritePre so nvim-lint's BufWritePost sees the formatted buffer.
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("conform_autoformat", { clear = true }),
      callback = function(args)
        if vim.g.autoformat == false then
          return
        end
        if vim.b[args.buf].autoformat == false then
          return
        end
        require("conform").format({
          bufnr = args.buf,
          async = false,
          lsp_format = "fallback",
        })
      end,
    })
  end,
}
