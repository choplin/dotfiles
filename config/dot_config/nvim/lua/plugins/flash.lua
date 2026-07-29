-- [Nav] Fast cursor motion with labels and treesitter integration.
--
--   s                  jump
--   S                  treesitter
--   r                  remote (operator)
--   R                  treesitter search
--   C-s                toggle in search
--   f/F/t/T/;/,        enhanced char motions (lazy; first press loads Flash)
--
-- Char keys intentionally omit an rhs so lz.n loads Flash, runs setup()
-- (which installs Flash's own char mappings), then replays the keypress.
return {
  "flash.nvim",
  src = "https://github.com/folke/flash.nvim",
  keys = {
    { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
    { "S", function() require("flash").treesitter() end, mode = { "n", "o", "x" }, desc = "Flash Treesitter" },
    { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
    { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
    { "<c-s>", function() require("flash").toggle() end, mode = "c", desc = "Toggle Flash Search" },
    { "f", mode = { "n", "x", "o" }, desc = "Flash f" },
    { "F", mode = { "n", "x", "o" }, desc = "Flash F" },
    { "t", mode = { "n", "x", "o" }, desc = "Flash t" },
    { "T", mode = { "n", "x", "o" }, desc = "Flash T" },
    { ";", mode = { "n", "x", "o" }, desc = "Flash ;" },
    { ",", mode = { "n", "x", "o" }, desc = "Flash ," },
  },
  after = function()
    require("flash").setup()
  end,
}
