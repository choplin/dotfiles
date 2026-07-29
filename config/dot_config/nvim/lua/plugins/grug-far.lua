-- [Nav] Search and replace UI with live preview.
--
--   <leader>sr         search and replace
--   :GrugFar           open search and replace
return {
  "grug-far.nvim",
  src = "https://github.com/MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
  after = function()
    require("grug-far").setup({ headerMaxWidth = 80 })
  end,
}
