-- [Misc] Interactive jq query and JSON list viewer.
--
--   :JqxList           list JSON keys
--   :JqxQuery          run jq query
return {
  "nvim-jqx",
  src = "https://github.com/gennaro-tedesco/nvim-jqx",
  cmd = { "JqxList", "JqxQuery" },
}
