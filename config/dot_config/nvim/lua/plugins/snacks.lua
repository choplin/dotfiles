-- [UI] Utility library: picker, dashboard, notifier, indent guides, statuscolumn, and more.
--
--   <leader>ff         find files
--   <leader>/          grep
--   <leader>fb         buffers
--   <leader>n          notification history
--   <leader>sg         grep
--   <leader>ss         LSP symbols
local function is_diffview_buf(buf)
  local ft = vim.bo[buf].filetype
  return ft == "DiffviewFiles" or ft == "DiffviewFilePanel" or ft == "DiffviewFileHistoryPanel"
end

return {
  "snacks.nvim",
  src = "https://github.com/folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  after = function()
    require("snacks").setup({
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        filter = function(buf)
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and not is_diffview_buf(buf)
        end,
      },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = {
        enabled = true,
        filter = function(buf)
          return vim.bo[buf].buftype == ""
            and vim.b[buf].snacks_scope ~= false
            and vim.g.snacks_scope ~= false
            and not is_diffview_buf(buf)
        end,
      },
      picker = { enabled = true },
      profiler = { enabled = true },
      statuscolumn = { enabled = true },
      toggle = { map = vim.keymap.set },
      words = { enabled = true },
      dim = {
        animate = { enabled = false },
      },
      styles = {
        lazygit = {
          width = 0.99,
          height = 0.99,
        },
      },
      dashboard = {
        preset = {
          header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":browse oldfiles" },
            { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
        },
      },
    })

    -- Statuscolumn (must be set after snacks is loaded)
    vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

    -- Keymaps
    vim.keymap.set("n", "<leader>n", function()
      Snacks.notifier.show_history()
    end, { desc = "Notification History" })
    vim.keymap.set("n", "<leader>un", function()
      Snacks.notifier.hide()
    end, { desc = "Dismiss All Notifications" })

    -- Picker keymaps
    require("config.snacks-picker")
  end,
}
