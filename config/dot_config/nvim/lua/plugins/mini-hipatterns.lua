-- [UI] Highlight patterns like hex colors inline.
return {
  "mini.hipatterns",
  src = "https://github.com/echasnovski/mini.hipatterns",
  event = "User LazyFile",
  after = function()
    local hi = require("mini.hipatterns")
    hi.setup({
      highlighters = {
        hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
        shorthand = {
          pattern = "()#%x%x%x()%f[^%x%w]",
          group = function(_, _, data)
            local match = data.full_match
            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
            local hex_color = "#" .. r .. r .. g .. g .. b .. b
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
          extmark_opts = { priority = 2000 },
        },
      },
    })
  end,
}
