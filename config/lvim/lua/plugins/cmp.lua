return {
  -- Enable command line completion
  {
    "hrsh7th/cmp-cmdline",
    require = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require "cmp"
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "cmdline", keyword_length = 1 },
        },
      })
    end,
  },
  -- Enable completion of symobols for "/" search
  {
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    require = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-cmdline" },
    config = function()
      local cmp = require "cmp"
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  -- Enable emoji completion
  {
    "hrsh7th/cmp-emoji",
    event = "InsertEnter",
    config = function()
      table.insert(lvim.builtin.cmp.sources, { name = "emoji" })
    end,
  },
  -- Provide AI code completion with Tabnine
  { "tzachar/cmp-tabnine", event = "InsertEnter", run = "./install.sh", requires = "hrsh7th/nvim-cmp" },
  -- Lookup dictionary
  {
    "octaltree/cmp-look",
    config = function()
      table.insert(lvim.builtin.cmp.sources, { name = "look" })
      lvim.builtin.cmp.formatting.source_names["look"] = "(Look)"
    end,
  },
  -- Completion from treesitter nodes
  {
    "ray-x/cmp-treesitter",
    config = function()
      lvim.builtin.cmp.formatting.source_names["treesitter"] = "(Treesitter)"
    end,
  },
}
