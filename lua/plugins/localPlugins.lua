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
}
