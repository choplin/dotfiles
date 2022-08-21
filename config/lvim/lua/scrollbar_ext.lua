local utils = require "scrollbar.utils"
local render = require("scrollbar").render

local M = {}

function M.hide_search_results()
  local bufnr = vim.api.nvim_get_current_buf()
  local scrollbar_marks = utils.get_scrollbar_marks(bufnr)
  scrollbar_marks.search = nil
  utils.set_scrollbar_marks(bufnr, scrollbar_marks)
  render()
end

return M
