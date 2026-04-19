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
      },
      formatters = {
        ["biome-check"] = { require_cwd = true },
      },
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    })

    -- Auto-format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("conform_autoformat", { clear = true }),
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end,
}
