-- GitHub Copilot Native LSP integration
-- Requires Neovim >= 0.12

-- Check Neovim version
if vim.fn.has("nvim-0.12") == 0 then
  vim.notify("Copilot Native requires Neovim >= 0.12", vim.log.levels.WARN)
  return {}
end

-- Disable AI completion in blink.cmp (native inline completions don't support being shown as regular completions)
vim.g.ai_cmp = false

local status = {} ---@type table<number, "ok" | "error" | "pending">

return {
  -- copilot-language-server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {
          -- stylua: ignore
          keys = {
            {
              "<M-]>",
              function() vim.lsp.inline_completion.select({ count = 1 }) end,
              desc = "Next Copilot Suggestion",
              mode = { "i", "n" },
            },
            {
              "<M-[>",
              function() vim.lsp.inline_completion.select({ count = -1 }) end,
              desc = "Prev Copilot Suggestion",
              mode = { "i", "n" },
            },
          },
        },
      },
      setup = {
        copilot = function()
          vim.schedule(function()
            vim.lsp.inline_completion.enable()
          end)
          -- Accept inline suggestions or next edits
          LazyVim.cmp.actions.ai_accept = function()
            return vim.lsp.inline_completion.get()
          end

          -- Only set up status handler if sidekick is not available
          if not LazyVim.has("sidekick.nvim") then
            vim.lsp.config("copilot", {
              handlers = {
                didChangeStatus = function(err, res, ctx)
                  if err then
                    return
                  end
                  status[ctx.client_id] = res.kind ~= "Normal" and "error" or res.busy and "pending" or "ok"
                  if res.status == "Error" then
                    vim.notify("Please use `:LspCopilotSignIn` to sign in to Copilot", vim.log.levels.ERROR)
                  end
                end,
              },
            })
          end
        end,
      },
    },
  },

  -- lualine integration
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      -- Skip if sidekick is available (it handles its own status display)
      if LazyVim.has("sidekick.nvim") then
        return
      end
      table.insert(
        opts.sections.lualine_x,
        2,
        LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
          local clients = vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
          return #clients > 0 and status[clients[1].id] or nil
        end)
      )
    end,
  },
}
