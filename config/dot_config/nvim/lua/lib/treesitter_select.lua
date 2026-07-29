-- Incremental syntax-node selection via Neovim's built-in Treesitter APIs.
-- Does not use the archived nvim-treesitter incremental_selection module.

local M = {}

---@param target 'parent'|'child'|'next'|'prev'|'extend_next'|'extend_prev'
local function select(target)
  local ok_parser = pcall(vim.treesitter.get_parser, 0, nil, { error = false })
  if not ok_parser then
    return
  end
  -- Quietly no-op when the buffer has no usable parser/node.
  pcall(vim.treesitter.select, target, vim.v.count1)
end

function M.init_or_expand()
  select("parent")
end

function M.shrink()
  select("child")
end

return M
