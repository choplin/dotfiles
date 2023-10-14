local M = require("lualine.component"):extend()
local modules = require("lualine_require").lazy_require({
  git_branch = "lualine.components.branch.git_branch",
  highlight = "lualine.highlight",
  utils = "lualine.utils.utils",
})

local branch_icon = ""

-- Initializer
M.init = function(self, options)
  M.super.init(self, options)
  if not self.options.icon then
    self.options.icon = branch_icon
  end
  modules.git_branch.init()
end

M.update_status = function(_, is_focused)
  local buf = (not is_focused and vim.api.nvim_get_current_buf())
  local branch = modules.git_branch.get_branch(buf)

  local ticket_branch = string.match(branch, "DLT%-%d+")
  if ticket_branch then
    branch = ticket_branch
  end

  return modules.utils.stl_escape(branch)
end

return M
