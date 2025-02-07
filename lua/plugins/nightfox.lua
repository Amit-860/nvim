return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        name = "nightfox",
        cond = not vim.g.vscode,
        priority = 1000,
        config = function()
            local opts = {
                -- options = {
                --     styles = { comments = "italic", keywords = "bold", types = "italic,bold" },
                -- },
                options = {
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        types = "bold",
                    },
                },
                palettes = {
                    -- terafox = {
                    --     bg1 = "#002f44",
                    -- },
                    nordfox = {
                        bg1 = "#1b1f26",
                    },
                },
                -- groups = { terafox = { CursorLine = { bg = "#092437" } } },
            }
            if vim.g.neovide then
                opts.palettes = { terafox = { bg1 = "#04131e", bg2 = "#192837" } }
                opts.groups = { terafox = { CursorLine = { bg = "#092437" } } }
            end
            require("nightfox").setup(opts)
        end,
    },
}
