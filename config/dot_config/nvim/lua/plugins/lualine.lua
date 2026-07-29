-- [UI] Status line with git, diagnostics, and file path display.
return {
  "lualine.nvim",
  src = "https://github.com/nvim-lualine/lualine.nvim",
  event = "DeferredUIEnter",
  after = function()
    -- Root directory display (cwd basename)
    local function root_dir()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end

    -- Pretty path: show relative path with shortened directories
    local function pretty_path()
      local path = vim.fn.expand("%:~:.")
      if path == "" then
        return ""
      end
      -- Shorten directory components
      local parts = vim.split(path, "/")
      if #parts > 3 then
        local shortened = {}
        for i = 1, #parts - 1 do
          table.insert(shortened, parts[i]:sub(1, 1))
        end
        table.insert(shortened, parts[#parts])
        path = table.concat(shortened, "/")
      end
      -- Show modified indicator
      if vim.bo.modified then
        path = path .. " ●"
      end
      return path
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { require("lib.lualine_branch") },
        lualine_c = {
          { root_dir, color = { fg = "#ff9e64", gui = "bold" } },
          "diagnostics",
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { pretty_path },
        },
        lualine_x = {
          {
            function()
              local ok, noice = pcall(require, "noice")
              return ok and noice.api.status.command.get() or ""
            end,
            cond = function()
              local ok, noice = pcall(require, "noice")
              return ok and noice.api.status.command.has()
            end,
          },
          {
            function()
              local ok, noice = pcall(require, "noice")
              return ok and noice.api.status.mode.get() or ""
            end,
            cond = function()
              local ok, noice = pcall(require, "noice")
              return ok and noice.api.status.mode.has()
            end,
          },
          "diff",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "fzf" },
    })
  end,
}
