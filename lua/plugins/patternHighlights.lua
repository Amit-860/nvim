return {
    {
        "brenoprata10/nvim-highlight-colors",
        cond = not vim.g.vscode,
        cmd = { "HighlightColors" },
        -- event = { 'BufReadPost', 'BufNewFile' },
        keys = {
            vim.keymap.set("n", "<F13>tp", function()
                vim.cmd("HighlightColors Toggle")
            end, { desc = "Highlights Colors", silent = true }),
        },
        opts = {
            ---@usage 'background'|'foreground'|'virtual'
            render = "virtual",
        },
    },
    {
        "folke/todo-comments.nvim",
        cond = not vim.g.vscode,
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "todo comment" }),
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" }),
            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" }),
        },
        opts = {
            signs = false, -- show icons in the signs column
            highlight = {
                pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
            },
            search = {
                pattern = [[\b(KEYWORDS)]], -- ripgrep regex
            },
        },
    },
}
