return {
  "render-markdown.nvim",
  src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  after = function()
    require("render-markdown").setup({
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = {} },
      checkbox = { enabled = false },
    })
    Snacks.toggle({
      name = "Render Markdown",
      get = require("render-markdown").get,
      set = require("render-markdown").set,
    }):map("<leader>um")
  end,
}
