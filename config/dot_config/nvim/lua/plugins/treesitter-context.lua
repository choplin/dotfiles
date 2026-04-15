return {
  "nvim-treesitter-context",
  event = "LazyFile",
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
