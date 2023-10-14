local M = {}

function M.merge(...)
  local l = {}
  for _, list in ipairs { ... } do
    for _, v in ipairs(list) do
      table.insert(l, v)
    end
  end
  return l
end

function M.map(list, f)
  local l = {}
  for _, v in ipairs(list) do
    table.insert(l, f(v))
  end
  return l
end

return M
