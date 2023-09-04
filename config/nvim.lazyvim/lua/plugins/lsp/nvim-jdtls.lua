local M = {}

M.setup = function()
  local util = require("lspconfig.util")
  local env = {
    HOME = vim.loop.os_homedir(),
    XDG_CACHE_HOME = os.getenv("XDG_CACHE_HOME"),
    JDTLS_JVM_ARGS = os.getenv("JDTLS_JVM_ARGS"),
  }

  local local_env = require("local_env")

  local cache_dir = util.path.join(env.XDG_CACHE_HOME or util.path.join(env.HOME, ".cache"), "jdtls")
  local config_dir = util.path.join(cache_dir, "config")
  local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])

  local function get_workspace_dir()
    local p = vim.fn.fnamemodify(root_dir, ":~:gs?/?_?")
    return util.path.join(cache_dir, "workspace", p:sub(3, p:len()))
  end

  local function get_jdtls_jvm_args()
    local args = {}
    for a in string.gmatch((env.JDTLS_JVM_ARGS or ""), "%S+") do
      local arg = string.format("--jvm-arg=%s", a)
      table.insert(args, arg)
    end
    return unpack(args)
  end

  local cmd = {
    "jdtls",
    "-configuration",
    config_dir,
    "-data",
    get_workspace_dir(),
    get_jdtls_jvm_args(),
  }

  local cmd_env = {
    JAVA_HOME = local_env.java.java_home_19,
  }

  local on_attach = function()
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
  end

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.workspace = {
    configuration = true,
  }

  local settings = {
    java = {
      ["java.format.settings.url"] = env.HOME .. ".config/lvim/misc/eclipse-java-google-style.xml",
      ["java.format.settings.profile"] = "GoogleStyle",
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-11",
            path = local_env.java.java_home_11,
          },
          {
            name = "JavaSE-19",
            path = local_env.java.java_home_19,
          },
        },
      },
    },
  }

  local on_init = function(client, _)
    client.notify("workspace/didChangeConfiguration", { settings = settings })
  end

  local init_options = {}

  local config = {
    cmd = cmd,
    cmd_env = cmd_env,
    filetypes = { "java" },
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = settings,
    init_options = init_options,
    root_dir = root_dir,
    flags = {
      allow_incremental_sync = true,
    },
  }

  require("jdtls").start_or_attach(config)

  -- require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
  --   local actions = require "telescope.actions"
  --   local opts = {}
  --   require("telescope.pickers").new(opts, {
  --     prompt_title    = prompt,
  --     finder          = require("telescope.finders").new_table {
  --       results = items,
  --       entry_maker = function(entry)
  --         return {
  --           value = entry,
  --           display = label_fn(entry),
  --           ordinal = label_fn(entry),
  --         }
  --       end,
  --     },
  --     sorter          = require("telescope.sorters").get_generic_fuzzy_sorter(),
  --     attach_mappings = function(prompt_bufnr)
  --       actions.goto_file_selection_edit:replace(function()
  --         local selection = actions.get_selected_entry(prompt_bufnr)
  --         actions.close(prompt_bufnr)
  --         cb(selection.value)
  --       end)
  --       return true
  --     end,
  --   }):find()
  -- end
end

return M
