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
            else
                vim.cmd('colorscheme dayfox')
            end
            require("local.colors")
        end
    },
}
