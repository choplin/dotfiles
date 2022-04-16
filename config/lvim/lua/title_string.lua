local M = {}

local project_dir_patterns = { ".git", "go.mod" }
local function find_project_dir(path)
  local dir
  if vim.fn.isdirectory(path) == 0 then
    dir = vim.fn.fnamemodify(path, ":h")
  else
    dir = path
  end

  local home_dir = vim.fn.fnamemodify("~", ":p")
  while true do
    for _, pat in pairs(project_dir_patterns) do
      if vim.fn.filewritable(dir .. "/" .. pat) > 0 then
        return dir
      end
    end
    local next = vim.fn.fnamemodify(dir, ":h")
    if next == home_dir or next == dir then
      break
    else
      dir = next
    end
  end
  return nil
end

local function title_string()
  local path = vim.fn.expand("%:p")
  local home_dir = vim.fn.fnamemodify("~", ":p")
  -- -- return the file path if the file exists outside home directory
  if not vim.startswith(path, home_dir) then
    return path
  end

  local project_dir = find_project_dir(path)
  -- return the file path relative to the home directory if the file exists outside project directory
  if project_dir == nil then
    return vim.fn.fnamemodify(path, ":~")
  end
  -- return the project directory name if found
  return vim.fn.fnamemodify(project_dir, ":t")
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
