return {
  "nvim-treesitter-context",
  src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
  event = "User LazyFile",
  after = function()
    require("treesitter-context").setup({
      mode = "cursor",
      max_lines = 3,
    })

    Snacks.toggle({
      name = "Treesitter Context",
      get = function()
        return require("treesitter-context").enabled()
      end,
      set = function(state)
        if state then
          require("treesitter-context").enable()
        else
          require("treesitter-context").disable()
        end
      end,
    }):map("<leader>ut")
  end,
}
