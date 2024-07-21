local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
    if not ok then
        return
    end
    return hl
end

return {
    {
        -- JQ utility
        dir = vim.fn.expand("./../local/jq"),
        cmd = { "Jq", "Jqf" },
        config = function()
            require("local.jq")
        end
    },
    {
        -- keybinds
        dir = vim.fn.expand("./../local/keybinds"),
        event = { "UIEnter" },
        config = function()
            require('local.lvimKeyBinds')
            require("local.keybinds")
        end
    },
    {
        -- colors
        dir = vim.fn.expand("./../local/colors"),
        event = { "VimEnter" },
        config = function()
            if vim.g.neovide then
                vim.cmd('colorscheme terafox')
                vim.api.nvim_set_hl(0, "BufferLineFill", { fg = "#001925", bg = "#001925" })
                require("local.colors")
            else
                require("local.colors")
                vim.cmd('colorscheme base16-emil')

                local h = get_hl('TelescopeBorder')
                vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#001925", bg = h['background'] })

                h = get_hl('TelescopeResultsTitle')
                vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#001925", bg = h['background'] })
                vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#001925", bg = h['background'] })

                h = get_hl('TelescopePromptBorder')
                vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#001925", bg = h['background'] })
            end
        end
    },
}
