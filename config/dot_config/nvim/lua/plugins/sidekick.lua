return {
  "sidekick.nvim",
  src = "https://github.com/folke/sidekick.nvim",
  keys = {
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    { "<c-.>", function() require("sidekick.cli").focus() end, desc = "Sidekick Focus", mode = { "n", "t", "i", "x" } },
    { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle CLI" },
    { "<leader>as", function() require("sidekick.cli").select() end, desc = "Select CLI" },
    { "<leader>ad", function() require("sidekick.cli").close() end, desc = "Detach a CLI Session" },
    { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, mode = { "x", "n" }, desc = "Send This" },
    { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send File" },
    { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = { "x" }, desc = "Send Visual Selection" },
    { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Sidekick Select Prompt" },
  },
  after = function()
    require("sidekick").setup({})

    Snacks.toggle({
      name = "Sidekick NES",
      get = function()
        return require("sidekick.nes").enabled
      end,
      set = function(state)
        require("sidekick.nes").enable(state)
      end,
    }):map("<leader>uN")
  end,
}
