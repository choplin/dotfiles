local M = {}

M.settings = function()
  local local_env = require("local_env")

  return {
    java = {
      ["java.format.settings.url"] = "file://" .. vim.fn.stdpath("config") .. "/jdtls/eclipse-java-google-style.xml",
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
          -- Java 8 and 21 seems not be supported by jdtls
          -- {
          --   name = "JavaSE-8",
          --   path = local_env.java.java_home_8,
          -- },
          {
            name = "JavaSE-11",
            path = local_env.java.java_home_11,
          },
          {
            name = "JavaSE-17",
            path = local_env.java.java_home_17,
          },
          -- {
          --   name = "JavaSE-21",
          --   path = local_env.java.java_home_21,
          -- },
        },
      },
    },
  }
end

return M
