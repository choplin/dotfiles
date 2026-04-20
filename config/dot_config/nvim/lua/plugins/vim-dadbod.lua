-- [Misc] Database client UI for SQL queries.
--
--   <leader>D          toggle DBUI
--   :DBUI              open database UI
--   :DBUIToggle        toggle database UI
--   :DBUIAddConnection add database connection
return {
  "vim-dadbod-ui",
  src = "https://github.com/kristijanhusak/vim-dadbod-ui",
  deps = {
    { src = "https://github.com/tpope/vim-dadbod", name = "vim-dadbod" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-completion", name = "vim-dadbod-completion" },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  keys = {
    { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
  },
  before = function()
    vim.cmd.packadd("vim-dadbod")
    vim.cmd.packadd("vim-dadbod-completion")

    local data_path = vim.fn.stdpath("data")
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true
    vim.g.db_ui_execute_on_save = false
  end,
}
