local M = {}

local function wrapped_git_sign()
  local statuscolumn = require("snacks.statuscolumn")
  local win = vim.g.statusline_winid

  if vim.wo[win].signcolumn == "no" then
    return ""
  end

  local buf = vim.api.nvim_win_get_buf(win)
  local signs = statuscolumn.line_signs(win, buf, vim.v.lnum, { git = true })

  for _, sign in ipairs(signs) do
    if sign.type == "git" then
      -- Git signs occupy the right-most status column slot in Snacks.
      return "%=" .. statuscolumn.icon(sign)
    end
  end

  return ""
end

function M.get()
  -- v:virtnum is positive for screen rows created by line wrapping.
  if vim.v.virtnum > 0 then
    return wrapped_git_sign()
  end

  return require("snacks.statuscolumn").get()
end

return M
