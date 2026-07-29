-- [Debug] Test runner framework with language-specific adapters.
--
--   <leader>tr         run nearest test
--   <leader>tt         run file
--   <leader>ts         summary
--   <leader>to         output
--   <leader>td         debug nearest test
return {
  "neotest",
  src = "https://github.com/nvim-neotest/neotest",
  deps = {
    { src = "https://github.com/nvim-neotest/nvim-nio", name = "nvim-nio" },
  },
  keys = {
    { "<leader>t", "", desc = "+test" },
    { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test" },
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
  },
  before = function()
    vim.cmd.packadd("nvim-nio")
  end,
  after = function()
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        end,
      },
    }, neotest_ns)

    require("neotest").setup({
      adapters = {},
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if pcall(require, "trouble") then
            require("trouble").open({ mode = "quickfix", focus = false })
          else
            vim.cmd("copen")
          end
        end,
      },
    })
  end,
}
