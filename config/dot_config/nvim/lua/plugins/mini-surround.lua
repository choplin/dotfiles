-- [Edit] Add, delete, find, and replace surrounding pairs.
--
--   gsa                add surrounding
--   gsd                delete surrounding
--   gsf                find surrounding
--   gsF                find surrounding (left)
--   gsr                replace surrounding
--   gsh                highlight surrounding
return {
  "mini.surround",
  src = "https://github.com/echasnovski/mini.surround",
  event = "DeferredUIEnter",
  after = function()
    require("mini.surround").setup({
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    })
  end,
}
