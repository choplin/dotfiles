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
        java = { "google-java-format" },
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
      },
      formatters = {
        ["biome-check"] = { require_cwd = true },
      },
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    })

    -- Auto-format on save (respects vim.g.autoformat and vim.b.autoformat)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("conform_autoformat", { clear = true }),
      callback = function(args)
        if vim.g.autoformat == false then
          return
        end
        if vim.b[args.buf].autoformat == false then
          return
        end
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end,
}
