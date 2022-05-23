return {
  -- Provide Github utility commands
  -- :Octo
  {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function() require "octo".setup() end
  },
  -- Provide better conflict UI and commands for resolving it
  { 'akinsho/git-conflict.nvim', config = function() require('git-conflict').setup() end },
  -- Provide fancy UI of git commit
  { "rhysd/committia.vim" },
  -- Automatically show diff in interactive git rebase window
  { "hotwatermorning/auto-git-diff" },
  -- Provide :Neogit, which
  {
    "TimUntersberger/neogit",
    requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require("neogit").setup { integrations = { diffview = true } }
    end
  },
  -- :DiffviewOpen, :DiffviewFileHistory provides neat diff UI
  {
    'sindrets/diffview.nvim',
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "Neogit" },
    requires = 'nvim-lua/plenary.nvim'
  },
}
