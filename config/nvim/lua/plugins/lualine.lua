local colors = {
  green = "#98be65",
  red = "#ec5f67",
  white = "#FFFFFF",
}

local function fg(name)
  ---@type {fg?:number}?
  local hl = vim.api.nvim_get_hl(0, { name = name })
  return hl and hl.fg and { fg = string.format("#%06x", hl.fg) }
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

local lsp = function()
  return {
    function()
      local buf_clients = vim.lsp.get_active_clients()
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add lsp client
      for _, client in pairs(buf_clients) do
        if client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end
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

      -- linters
      local lint_ok, lint = pcall(require, "lint")
      if lint_ok then
        local lint_linters = lint.linters_by_ft[buf_ft] or {}
        vim.list_extend(buf_client_names, lint_linters)
      end

      -- remove duplicates
      local unique_client_names = vim.fn.uniq(buf_client_names) or {}

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

local copilot_colors = {
  [""] = { fg = colors.white },
  ["Normal"] = { fg = colors.white },
  ["Warning"] = fg("DiagnosticError"),
  ["InProgress"] = fg("DiagnosticWarn"),
}

local copilot = function()
  return {
    function()
      local icon = require("lazyvim.config").icons.kinds.Copilot
      local status = require("copilot.api").status.data
      return icon .. (status.message or "")
    end,
    cond = function()
      if not package.loaded["copilot"] then
        return
      end
      local ok, clients = pcall(require("lazyvim.util").lsp.get_clients, { name = "copilot", bufnr = 0 })
      if not ok then
        return false
      end
      return ok and #clients > 0
    end,
    color = function()
      if not package.loaded["copilot"] then
        return
      end
      local status = require("copilot.api").status.data
      return copilot_colors[status.status] or copilot_colors[""]
    end,
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
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = fg("Debug"),
        },
        { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
        treesitter(icons),
        lsp(),
        copilot(),
      }
      opts.extensions = { "neo-tree", "lazy", "aerial", "nvim-dap-ui", "quickfix" }
    end,
  },
}
