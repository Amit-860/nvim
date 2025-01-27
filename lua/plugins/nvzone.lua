return {
    { "nvzone/volt", lazy = true, event = "VeryLazy", cond = not vim.g.vscode },
    {
        "nvzone/minty",
        cmd = { "Shades", "Huefy" },
        keys = {
            vim.api.nvim_set_keymap("n", "<F13>cs", "<cmd>Shades<cr>", { desc = "Shades" }),
            vim.api.nvim_set_keymap("n", "<F13>ch", "<cmd>Huefy<cr>", { desc = "Huefy" }),
        },
        cond = not vim.g.vscode,
    },
    {
        "nvzone/showkeys",
        cmd = "ShowkeysToggle",
        keys = {
            vim.api.nvim_set_keymap("n", "<F13>tk", "<cmd>ShowkeysToggle<cr>", { desc = "ShowkeysToggle" }),
        },
        opts = {
            timeout = 1,
            maxkeys = 5,
            winhl = "FloatBorder:FloatBorder,Normal:NormalFloat",
            row = 1,
            col = 0,
        },
    },
}
