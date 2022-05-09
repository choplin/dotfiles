local M = {}

function M.concatLists(...)
  local lists = { ... }
  local ret = {}
  for i = 1, #lists do
    local l = lists[i]
    for j = 1, #l do
      table.insert(ret, l[j])
    end
  end
  return ret
end

return M
