return {
  "neogen",
  src = "https://github.com/danymat/neogen",
  cmd = "Neogen",
  keys = {
    { "<leader>cn", function() require("neogen").generate() end, desc = "Generate Annotations (Neogen)" },
  },
  after = function()
    require("neogen").setup({
      snippet_engine = "nvim",
    })
  end,
}
