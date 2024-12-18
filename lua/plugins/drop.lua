return {
    "folke/drop.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
        theme = "auto", -- when auto, it will choose a theme based on the date
        max = 24, -- maximum number of drops on the screen
        interval = 200, -- every 150ms we update the drops
        screensaver = 1000 * 60 * 10, -- show after 5 minutes. Set to false, to disable
        filetypes = { "dashboard", "alpha", "ministarter" }, -- will enable/disable automatically for the following filetypes
        winblend = 100, -- winblend for the drop window
    },
}
