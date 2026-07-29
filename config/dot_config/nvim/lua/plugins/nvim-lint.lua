-- [LSP] Async linter integration (shellcheck, golangci-lint, markdownlint, etc.).
return {
  "nvim-lint",
  src = "https://github.com/mfussenegger/nvim-lint",
  event = "User LazyFile",
  after = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
      markdown = { "markdownlint-cli2" },
    }

    -- Debounced lint on save/read/insert leave
    local timer = vim.uv.new_timer()
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
      callback = function()
        timer:stop()
        timer:start(100, 0, vim.schedule_wrap(function()
          lint.try_lint()
        end))
      end,
    })
  end,
}
