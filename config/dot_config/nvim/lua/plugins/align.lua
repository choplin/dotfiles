-- [Edit] Text alignment by character, string, or regex pattern.
--
--   <leader>Aa        align to char (visual)
--   <leader>As        align to 2 chars (visual)
--   <leader>Aw        align to string (visual)
--   <leader>Ar        align to regex (visual)
return {
  "align.nvim",
  src = "https://github.com/Vonr/align.nvim",
  keys = {
    {
      "<leader>Aa",
      function() require("align").align_to_char({ length = 1, reverse = true }) end,
      mode = { "x" },
      desc = "Aligns to 1 character, looking left",
    },
    {
      "<leader>As",
      function() require("align").align_to_char({ length = 2, reverse = true, preview = true }) end,
      mode = { "x" },
      desc = "Aligns to 2 characters, looking left and with previews",
    },
    {
      "<leader>Aw",
      function() require("align").align_to_string({ regex = false, reverse = true, preview = true }) end,
      mode = { "x" },
      desc = "Aligns to a string, looking left and with previews",
    },
    {
      "<leader>Ar",
      function() require("align").align_to_string({ regex = true, reverse = true, preview = true }) end,
      mode = { "x" },
      desc = "Aligns to a Lua pattern, looking left and with previews",
    },
  },
}
