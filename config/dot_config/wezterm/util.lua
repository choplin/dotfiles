local M = {}

-- Merge multiple lists into one
-- @param ... table: The lists to merge
-- @return table: A new list containing all elements from the input lists
function M.merge(...)
  local l = {}
  for _, list in ipairs({ ... }) do
    for _, v in ipairs(list) do
      table.insert(l, v)
    end
  end
  return l
end

-- Map a function over a list
-- @param list table: The list to map over
-- @param f function: The function to apply to each element
function M.map(list, f)
  local l = {}
  for _, v in ipairs(list) do
    table.insert(l, f(v))
  end
  return l
end

-- Check if any element in the list satisfies the predicate function
-- @param list table: The list to filter
-- @param f function: The predicate function to apply to each element
-- @return boolean: True if any element satisfies the predicate, false otherwise
function M.any(list, f)
  for i = 1, #list do
    if f(list[i]) then
      return true
    end
  end
end

-- Check if a file exists at the given path
-- @param path string: The file path to check
-- @return boolean: True if the file exists, false otherwise
function M.exists(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
