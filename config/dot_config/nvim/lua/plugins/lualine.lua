-- [UI] Status line with git, diagnostics, and file path display.
return {
  "lualine.nvim",
  src = "https://github.com/nvim-lualine/lualine.nvim",
  event = "DeferredUIEnter",
  after = function()
    -- Root directory display (shared project root basename)
    local function root_dir()
      return require("lib.root").pretty()
    end

    -- Pretty path: show relative path with shortened directories
    local function pretty_path()
      local path = vim.fn.expand("%:~:.")
      if path == "" then
        return ""
      end
      local parts = vim.split(path, "/")
      if #parts > 3 then
        local shortened = {}
        for i = 1, #parts - 1 do
          table.insert(shortened, parts[i]:sub(1, 1))
        end
        table.insert(shortened, parts[#parts])
        path = table.concat(shortened, "/")
      end
      if vim.bo.modified then
        path = path .. " ●"
      end
      return path
    end

    -- Trouble symbols: create the statusline helper only after Trouble itself is loaded.
    local trouble_symbols ---@type { get: fun(): string, has: fun(): boolean }|nil
    local function ensure_trouble_symbols()
      if trouble_symbols then
        return trouble_symbols
      end
      if not package.loaded["trouble"] then
        return nil
      end
      trouble_symbols = require("trouble").statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      return trouble_symbols
    end

    -- Profiler status without requiring snacks.profiler until it is already loaded.
    local profiler_status = {
      function()
        local profiler = package.loaded["snacks.profiler"]
        if not profiler or not profiler.running() then
          return ""
        end
        local icon = vim.tbl_get(profiler, "config", "icons", "status") or "󰈸 "
        return ("%s %d events"):format(icon, #profiler.core.events)
      end,
      color = "DiagnosticError",
      cond = function()
        local profiler = package.loaded["snacks.profiler"]
        return profiler ~= nil and profiler.running()
      end,
    }

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
          {
            function()
              local symbols = ensure_trouble_symbols()
              return symbols and symbols.get() or ""
            end,
            cond = function()
              if vim.b.trouble_lualine == false then
                return false
              end
              local symbols = ensure_trouble_symbols()
              return symbols ~= nil and symbols.has()
            end,
          },
        },
        lualine_x = {
          profiler_status,
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
          },
          "diff",
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location" },
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "neo-tree", "fzf" },
    })
  end,
}
