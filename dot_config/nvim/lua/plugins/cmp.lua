local cmp = require("cmp")

local source_names = {
  nvim_lsp = "(LSP)",
  emoji = "(Emoji)",
  path = "(Path)",
  cmp_tabnine = "(Tabnine)",
  buffer = "(Buffer)",
  treesitter = "(TreeSitter)",
  look = "(Look)",
}

local cmdline_select_next_item = function()
  if cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
  else
    cmp.complete()
  end
end

local cmdline_select_prev_item = function()
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
  else
    cmp.complete()
  end
end

local cmdline_keymap = {
  ["<C-j>"] = cmp.mapping(cmdline_select_next_item, { "c" }),
  ["<C-k>"] = cmp.mapping(cmdline_select_prev_item, { "c" }),
  ["<Tab>"] = cmp.mapping(cmdline_select_next_item, { "c" }),
  ["<S-Tab>"] = cmp.mapping(cmdline_select_prev_item, { "c" }),
  ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "c" }),
  ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "c" }),
}

return {
  -- Enable command line completion
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
    config = function()
      cmp.setup.cmdline(":", {
        mapping = cmdline_keymap,
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
        mapping = cmdline_keymap,
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
  -- Cmp sources for Git
  {
    "petertriho/cmp-git",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    main = "cmp_git",
    opts = {},
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
      "hrsh7th/cmp-emoji",
      "ray-x/cmp-treesitter",
      -- "octaltree/cmp-look",
      "tzachar/cmp-tabnine",
      "petertriho/cmp-git",
    },
    opts = function(_, opts)
      local select_next_item = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })
      local select_prev_item = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })

      opts.preselect = cmp.PreselectMode.None
      opts.completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      }
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping(select_next_item, { "i" }),
        ["<C-k>"] = cmp.mapping(select_prev_item, { "i" }),
        ["<C-n>"] = cmp.mapping(select_next_item, { "i" }),
        ["<C-p>"] = cmp.mapping(select_prev_item, { "i" }),
        ["<Down>"] = cmp.mapping(select_next_item, { "i" }),
        ["<Up>"] = cmp.mapping(select_prev_item, { "i" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
        ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
        ["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i" }),
      })
      opts.sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "treesitter" },
        -- { name = "look" },
        -- { name = "cmp_tabnine" },
        { name = "git" },
        { name = "emoji", max_item_count = 5, priority = 0 },
      }
    end,
  },
}
