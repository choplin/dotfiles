-- [UI] File type icon provider with nvim-web-devicons compatibility.
return {
  "mini.icons",
  src = "https://github.com/echasnovski/mini.icons",
  -- Eager: icon provider mocked as nvim-web-devicons for UI plugins at startup.
  lazy = false,
  priority = 100,
  after = function()
    require("mini.icons").setup({
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    })
    MiniIcons.mock_nvim_web_devicons()
  end,
}
