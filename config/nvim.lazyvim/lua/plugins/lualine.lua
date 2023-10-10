local colors = {
  green = "#98be65",
  red = "#ec5f67",
}

local function fg(name)
  return function()
    ---@type {fg?:number}?
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return hl and hl.fg and { fg = string.format("#%06x", hl.fg) }
  end
end

local treesitter = function(icons)
  return {
    function()
      return icons.custom.Tree
    end,
    separator = { left = nil },
    padding = 1,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
    end,
  }
end

local lsp = function(icons)
  return {
    function()
      local buf_clients = vim.lsp.get_active_clients()
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add lsp client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end

        if client.name == "copilot" then
          copilot_active = true
        end
      end

      -- null-ls sources
      local null_ls_ok, _ = pcall(require, "null-ls")
      if null_ls_ok then
        local null_ls_sources = require("null-ls.sources").get_available(buf_ft)
        local null_ls_source_names = vim.tbl_map(function(s)
          return s.name
        end, null_ls_sources)
        vim.list_extend(buf_client_names, null_ls_source_names)
      end

      -- formatters
      local conform_ok, conform = pcall(require, "conform")
      if conform_ok then
        local conform_formatters = conform.list_formatters(0)
        local conform_formatter_names = vim.tbl_map(function(f)
          return f.name
        end, conform_formatters)
        vim.list_extend(buf_client_names, conform_formatter_names)
      end

      -- remove duplicates
      local unique_client_names = vim.fn.uniq(buf_client_names) or {}

      -- append copilot icon
      if copilot_active then
        table.insert(unique_client_names, icons.custom.Copilot)
      end

      if next(unique_client_names) == nil then
        return "LS Inactive"
      end

      return "[" .. table.concat(unique_client_names, ", ") .. "]"
    end,
    separator = { left = nil },
    padding = { left = 0, right = 1 },
    color = { gui = "bold" },
  }
end

return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      opts.sections.lualine_b = {
        require("lualine_branch"),
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
        },
      }
      opts.sections.lualine_x = {
        -- stylua: ignore
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = fg("Statement")
        },
        -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = fg("Constant"),
        },
        { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
        treesitter(icons),
        lsp(icons),
      }
      opts.extensions = { "neo-tree", "lazy", "aerial", "nvim-dap-ui", "quickfix" }
    end,
  },
}
