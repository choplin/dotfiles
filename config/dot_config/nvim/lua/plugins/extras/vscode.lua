-- VSCode Neovim extension integration
-- Only active when running inside VSCode with the Neovim extension

if not vim.g.vscode then
  return {}
end

-- List of plugins that work well in VSCode
local enabled = {
  "dial.nvim",
  "flash.nvim",
  "lazy.nvim",
  "mini.ai",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "snacks.nvim",
  "ts-comments.nvim",
  "vim-repeat",
  "yanky.nvim",
}

local Config = require("lazy.core.config")
local vscode = require("vscode")

-- Disable lazy.nvim checker and change detection in VSCode
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false

-- Only load enabled plugins
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- Disable snacks animations
vim.g.snacks_animate = false

-- Add VSCode-specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymapsDefaults",
  callback = function()
    -- VSCode-specific keymaps for search and navigation
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    vim.keymap.set("n", "<leader>/", function()
      vscode.call("workbench.action.findInFiles")
    end)
    vim.keymap.set("n", "<leader>ss", function()
      vscode.call("workbench.action.gotoSymbol")
    end)

    -- Toggle VS Code integrated terminal
    for _, lhs in ipairs({ "<leader>ft", "<leader>fT", "<c-/>" }) do
      vim.keymap.set("n", lhs, function()
        vscode.call("workbench.action.terminal.toggleTerminal")
      end)
    end

    -- Navigate VSCode tabs like lazyvim buffers
    vim.keymap.set("n", "<S-h>", function()
      vscode.call("workbench.action.previousEditor")
    end)
    vim.keymap.set("n", "<S-l>", function()
      vscode.call("workbench.action.nextEditor")
    end)
  end,
})

return {
  -- Disable snacks features that VSCode handles
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
    },
  },

  -- Disable treesitter highlight (VSCode handles syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
