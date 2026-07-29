-- [Misc] Browser-based markdown preview.
--
--   <leader>cp         toggle preview
--   :MarkdownPreviewToggle  toggle markdown preview
return {
  "markdown-preview.nvim",
  src = "https://github.com/iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  keys = {
    { "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
  },
}
