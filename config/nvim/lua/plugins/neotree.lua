local renderer = require("neo-tree.ui.renderer")

-- Move to the parent folder.
local function neotree_h(state)
  local node = state.tree:get_node()
  if not node then
    return
  end

  local parent = node:get_parent_id()
  if parent then
    renderer.focus_node(state, node:get_parent_id())
  end
end

return {
  -- Override the default settings.
  -- File browser on the side bar
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
        winbar = true,
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = neotree_h,
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
        },
        follow_current_file = {
          enabled = true,
        },
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
        scan_mode = "deep",
      },
    },
  },
}
