-- vim: ft=lua tw=80

stds.nvim = {
    globals = {
        vim = { fields = { "g" } },
    },
    read_globals = {
        "vim",
    },
}
std = "lua51+nvim"
