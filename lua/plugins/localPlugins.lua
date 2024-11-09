return {
    {
        -- JQ utility
        dir = vim.fn.expand("./../local/jq"),
        cmd = { "Jq", "Jqf" },
        config = function()
            require("local.jq")
        end,
    },
    {
        -- keybinds
        dir = vim.fn.expand("./../local/keybinds"),
        event = { "UIEnter" },
        config = function()
            require("local.lvimKeyBinds")
            require("local.keybinds")
        end,
    },
    {
        -- colors
        dir = vim.fn.expand("./../local/colors"),
        event = { "UIEnter" },
        config = function()
            require("local.colors")
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("colors", { clear = true }),
                callback = function(event)
                    require("local.colors")
                end,
            })
        end,
    },
    {
        -- fixing colorscheme setting issue
        dir = vim.fn.expand("./"),
        lazy = false,
        priority = 900,
        config = function()
            if vim.g.neovide then
                vim.cmd("colorscheme " .. vim.g.neovide_colorscheme)
            else
                vim.cmd("colorscheme " .. vim.g.colorscheme)
            end
        end,
    },
    {
        -- coderunner
        dir = vim.fn.expand("./../local/codeRunner"),
        cmd = { "RunCode", "ReopenLastOutput" },
        cond = not vim.g.vscode,
        config = function()
            local runTA = require("local.codeRunner")
            runTA.setup({
                output_window_type = "floating", -- floating, pane, tab, split
                output_window_configs = {
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                    position = "center", -- Position of the floating window ("center", "top", "bottom", "left", "right", "custom")
                    custom_col = nil,
                    custom_row = nil,
                    transparent = false,
                },
            })
        end,
    },
}
