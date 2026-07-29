-- Shared project-root and git-root resolution (framework-free; no LazyVim).
--
-- Detection order for project root:
--   1. Innermost LSP client root that contains the buffer path
--   2. Innermost filesystem marker (see M.markers)
--   3. Current working directory
--
-- Git root is resolved separately via an upward `.git` search so Git-scoped
-- consumers (lazygit, git log) do not collapse into project-root detection.

local M = {}

---@type string[]
M.markers = {
  ".git",
  ".jj",
  "flake.nix",
  "Cargo.toml",
  "go.mod",
  "package.json",
  "pyproject.toml",
  "composer.json",
  "Makefile",
  ".project",
  ".neoconf.json",
}

---@type table<number, { root?: string, git?: string|false, path?: string }>
local cache = {}

local function normalize(path)
  if not path or path == "" then
    return nil
  end
  path = vim.fs.normalize(path)
  return path ~= "" and path or nil
end

---@param buf? number
---@return string
local function buf_dir(buf)
  buf = buf or 0
  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" then
    return vim.fs.dirname(vim.fs.normalize(name))
  end
  return normalize(vim.uv.cwd()) or vim.fn.getcwd()
end

---@param buf? number
---@return boolean
local function cache_valid(buf)
  buf = buf or 0
  local entry = cache[buf]
  if not entry then
    return false
  end
  local name = vim.api.nvim_buf_get_name(buf)
  return entry.path == name
end

--- Clear cached roots (all buffers, or one).
---@param buf? number
function M.clear(buf)
  if buf then
    cache[buf] = nil
  else
    cache = {}
  end
end

--- Current working directory for CWD-scoped operations.
---@return string
function M.cwd()
  return normalize(vim.uv.cwd()) or vim.fn.getcwd()
end

--- Git root for the buffer, or nil when not inside a Git work tree.
---@param buf? number
---@return string?
function M.git(buf)
  buf = buf or 0
  if cache_valid(buf) and cache[buf].git ~= nil then
    return cache[buf].git ~= false and cache[buf].git or nil
  end

  local dir = buf_dir(buf)
  local found = vim.fs.find({ ".git" }, {
    path = dir,
    upward = true,
    type = "directory",
  })[1]
  -- `.git` may also be a file (worktrees / submodules)
  if not found then
    found = vim.fs.find({ ".git" }, {
      path = dir,
      upward = true,
    })[1]
  end

  local root = found and normalize(vim.fs.dirname(found)) or nil
  cache[buf] = cache[buf] or {}
  cache[buf].path = vim.api.nvim_buf_get_name(buf)
  cache[buf].git = root or false
  return root
end

---@param buf? number
---@return string?
local function detect_lsp(buf)
  buf = buf or 0
  local dir = buf_dir(buf)
  local best ---@type string?
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    local roots = {}
    if client.root_dir then
      roots[#roots + 1] = client.root_dir
    end
    local ws = client.workspace_folders
    if ws then
      for _, folder in ipairs(ws) do
        roots[#roots + 1] = vim.uri_to_fname(folder.uri)
      end
    end
    for _, root in ipairs(roots) do
      root = normalize(root)
      if root and (dir == root or dir:sub(1, #root + 1) == root .. "/") then
        if not best or #root > #best then
          best = root
        end
      end
    end
  end
  return best
end

---@param buf? number
---@return string?
local function detect_markers(buf)
  local dir = buf_dir(buf)
  local found = vim.fs.find(M.markers, {
    path = dir,
    upward = true,
  })[1]
  return found and normalize(vim.fs.dirname(found)) or nil
end

--- Resolve the shared project root for a buffer.
---@param opts? { buf?: number, skip_lsp?: boolean }
---@return string
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or 0

  if cache_valid(buf) and cache[buf].root then
    return cache[buf].root
  end

  local root = (not opts.skip_lsp and detect_lsp(buf)) or detect_markers(buf) or M.cwd()
  cache[buf] = cache[buf] or {}
  cache[buf].path = vim.api.nvim_buf_get_name(buf)
  cache[buf].root = root
  return root
end

--- Basename of the resolved project root (for statusline display).
---@param opts? { buf?: number }
---@return string
function M.pretty(opts)
  return vim.fn.fnamemodify(M.get(opts), ":t")
end

-- Invalidate cache when buffers rename or leave, and when LSP attaches (richer root).
vim.api.nvim_create_autocmd({ "LspAttach", "BufFilePost", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("lib_root_cache", { clear = true }),
  callback = function(ev)
    if ev.event == "DirChanged" then
      M.clear()
    else
      M.clear(ev.buf)
    end
  end,
})

return M
