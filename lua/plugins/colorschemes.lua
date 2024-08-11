return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local opts = {
                options = {
                    styles = { comments = "italic", keywords = "bold", types = "italic,bold" },
                },
                palettes = { terafox = { bg1 = "#002f44" } },
                groups = { terafox = { CursorLine = { bg = "#092437" } } },
            }
            if vim.g.neovide then
                opts.palettes = { terafox = { bg1 = "#04131e", bg2 = "#192837" } }
                opts.groups = { terafox = { CursorLine = { bg = "#092437" } } }
            end
            require("nightfox").setup(opts)

            if vim.g.neovide then
                vim.cmd("colorscheme " .. vim.g.neovide_colorscheme)
                vim.api.nvim_set_hl(0, "BufferLineFill", { fg = "#001925", bg = "#001925" })
            else
                vim.cmd("colorscheme " .. vim.g.colorscheme)
            end
        end,
    },
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    },
}
