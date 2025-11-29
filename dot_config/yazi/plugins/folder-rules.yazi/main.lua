local function setup()
  ps.sub("cd", function()
    local cwd = cx.active.current.cwd
    if cwd:ends_with("Downloads") then
      ya.emit("sort", { "extension", reverse = false, dir_first = true })
    else
      ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
    end
  end)
end

return { setup = setup }
