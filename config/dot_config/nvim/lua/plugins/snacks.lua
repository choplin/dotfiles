local function is_diffview_buf(buf)
  local ft = vim.bo[buf].filetype
  return ft == "DiffviewFiles" or ft == "DiffviewFilePanel" or ft == "DiffviewFileHistoryPanel"
end

return {
  "snacks.nvim",
  lazy = false,
  priority = 1000,
  after = function()
    require("snacks").setup({
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
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
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
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>n", function()
      Snacks.notifier.show_history()
    end, { desc = "Notification History" })
    vim.keymap.set("n", "<leader>un", function()
      Snacks.notifier.hide()
    end, { desc = "Dismiss All Notifications" })
  end,
}
