local cmp = require("cmp")

local source_names = {
  nvim_lsp = "(LSP)",
  emoji = "(Emoji)",
  path = "(Path)",
  cmp_tabnine = "(Tabnine)",
  luasnip = "(Snippet)",
  buffer = "(Buffer)",
  copilot = "(Copilot)",
  treesitter = "(TreeSitter)",
  look = "(Look)",
}

return {
  -- Enable command line completion
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
    config = function()
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
    lazy = true,
    config = function()
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
        }),
      })
    end,
  },
  -- Provide AI code completion with Tabnine
  {
    "tzachar/cmp-tabnine",
    lazy = true,
    build = "./install.sh",
  },
  -- Auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-emoji",
      "ray-x/cmp-treesitter",
      "octaltree/cmp-look",
      "tzachar/cmp-tabnine",
    },
    opts = function(_, opts)
      opts.completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      }
      opts.mapping = vim.tbl_deep_extend(
        "force",
        opts.mapping,
        cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
        })
      )
      opts.sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "look" },
        { name = "cmp_tabnine" },
        { name = "copilot" },
      }
      opts.formatting = {
        format = function(entry, item)
          local icons = require("lazyvim.config").icons.kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          if source_names[entry.source.name] then
            item.menu = source_names[entry.source.name]
          end
          return item
        end,
      }
    end,
  },
}
