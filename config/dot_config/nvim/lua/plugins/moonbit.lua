-- [Lang] MoonBit language support (LSP, mooncakes, compiler integration).
-- Treesitter parser/queries ship from the Neovim Nix closure (neovim.nix).
-- Toolchain (moon / moonfmt / moon-lsp) is expected from the project flake.
--
--   :MoonbitLspRestart restart language server
return {
  "moonbit.nvim",
  src = "https://github.com/moonbit-community/moonbit.nvim",
  deps = {
    { src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary.nvim" },
  },
  ft = { "moonbit" },
  before = function()
    -- mooncakes.api.http requires plenary.curl at module load time
    -- (even when use_local = true).
    vim.cmd.packadd("plenary.nvim")
  end,
  after = function()
    -- moonbit.nvim computes `treesitter_opts.enabled or true`, so
    -- `enabled = false` is ignored and it always calls nvim-treesitter.
    -- This config ships parsers via Nix and does not use that runtime.
    package.loaded["moonbit.treesitter"] = {
      setup = function() end,
    }

    require("moonbit").setup({
      mooncakes = {
        virtual_text = true,
        use_local = true,
      },
      lsp = {
        -- Prefer native moon-lsp when available on PATH (project flake).
        native = true,
      },
    })

    -- lz.n loads on FileType after the event already fired for the current
    -- buffer; re-fire so editor/compiler attach hooks run once.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "moonbit" then
        vim.api.nvim_exec_autocmds("FileType", {
          buffer = buf,
          modeline = false,
        })
      end
    end
  end,
}
