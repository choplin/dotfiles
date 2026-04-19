return {
  "octo.nvim",
  src = "https://github.com/pwntester/octo.nvim",
  cmd = "Octo",
  keys = {
    { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
    { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
    { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
    { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
    { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
    { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
  },
  after = function()
    vim.treesitter.language.register("markdown", "octo")
    require("octo").setup({
      enable_builtin = true,
      default_to_projects_v2 = true,
      default_merge_method = "squash",
      picker = "snacks",
    })
  end,
}
