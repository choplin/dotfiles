local M = {}

local function title_string()
  local path = vim.fn.expand("%:~", false, false)
  if vim.startswith(path, "term://") then
    path = vim.bo.filetype
  end

  -- -- return the file path if the file exists outside home directory
  if not vim.startswith(path, "~") then
    return path
  end

  local project_root = require('project_nvim.project').get_project_root()
  -- return the file path relative to the home directory if the file exists outside project directory
  if project_root == nil then
    return path
  end
  -- return the project directory name if found
  return vim.fn.fnamemodify(project_root, ":t")
end

function M.title_string()
  local title = vim.fn.getbufvar(0, "title_string")
  if title == "" then
    title = title_string()
    vim.fn.setbufvar(0, "title_string", title)
  end
  return title
end

return M
