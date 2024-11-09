return {
    "Axlefublr/selabel.nvim",
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    opts = {
        win_opts = {
            border = "single",
        },
    },
}
