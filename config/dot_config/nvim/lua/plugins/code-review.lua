return {
  "code-review.nvim",
  dir = "/Users/aki/private-workspace/code-review.nvim",
  enabled = false, -- loaded by init.lua local plugin loader, not lz.n
  after = function()
    require("code-review").setup({
      ui = {
        preview = {
          split = "float",
        },
        virtual_text = {
          enabled = true,
        },
      },
      comment = {
        storage = {
          backend = "memory",
        },
        auto_copy_on_add = true,
      },
      output = {
        format = "minimal",
      },
    })
  end,
}
