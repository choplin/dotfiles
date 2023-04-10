local M = {}

local ft_to_ignore = {
  "neo-tree",
  "lazy",
}

---@return string?
local function get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil

  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if r and path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  return roots[1]
end

---@return string?
local function _title_string()
  if vim.tbl_contains(ft_to_ignore, vim.bo.filetype) then
    return
  end

  local root = get_root()
  if root == nil then
    return vim.fn.expand("%:~", false)
  end

  -- return the project directory name if found
  return vim.fn.fnamemodify(root, ":t") .. " - " .. vim.v.progname
end
-- - %{v:progname}
function M.title_string()
  local title = vim.fn.getbufvar(0, "title_string")
  if title == "" then
    title = _title_string()
    if title == nil then
      title = vim.v.progname
    end
    vim.fn.setbufvar(0, "title_string", title)
  end
  return title
end

return M
