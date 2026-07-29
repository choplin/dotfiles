-- Context module for copying file location and context
local M = {}

--- Get the current file path relative to the shared project root (or cwd fallback)
---@return string
local function get_relative_path()
  local file = vim.fn.expand("%:p")
  local root = require("lib.root").get()

  if file:sub(1, #root) == root then
    file = file:sub(#root + 2)
  end

  return file
end

--- Copy file location (path:line) to clipboard
function M.copy_file_location()
  local file = get_relative_path()
  local line = vim.fn.line(".")
  local location = string.format("%s:%d", file, line)
  vim.fn.setreg("+", location)
  vim.notify("Copied: " .. location, vim.log.levels.INFO)
end

--- Copy file context with surrounding lines
---@param context_lines number Number of lines before and after current line
function M.copy_file_context(context_lines)
  local file = get_relative_path()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  local start_line = math.max(1, current_line - context_lines)
  local end_line = math.min(total_lines, current_line + context_lines)

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local content = table.concat(lines, "\n")

  local result = string.format("%s:%d-%d\n```\n%s\n```", file, start_line, end_line, content)
  vim.fn.setreg("+", result)
  vim.notify(string.format("Copied: %s:%d-%d", file, start_line, end_line), vim.log.levels.INFO)
end

--- Copy visual selection location to clipboard
function M.copy_visual_location()
  local file = get_relative_path()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  local location
  if start_line == end_line then
    location = string.format("%s:%d", file, start_line)
  else
    location = string.format("%s:%d-%d", file, start_line, end_line)
  end

  vim.fn.setreg("+", location)
  vim.notify("Copied: " .. location, vim.log.levels.INFO)
end

--- Copy visual selection with context to clipboard
function M.copy_visual_context()
  local file = get_relative_path()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local content = table.concat(lines, "\n")

  local result
  if start_line == end_line then
    result = string.format("%s:%d\n```\n%s\n```", file, start_line, content)
  else
    result = string.format("%s:%d-%d\n```\n%s\n```", file, start_line, end_line, content)
  end

  vim.fn.setreg("+", result)
  if start_line == end_line then
    vim.notify(string.format("Copied: %s:%d", file, start_line), vim.log.levels.INFO)
  else
    vim.notify(string.format("Copied: %s:%d-%d", file, start_line, end_line), vim.log.levels.INFO)
  end
end

return M
