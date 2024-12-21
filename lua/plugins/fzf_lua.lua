return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local actions = require("fzf-lua.actions")
        local icons = require("icons")
        return {
            -- Make stuff better combine with the editor.
            fzf_colors = {
                bg = { "bg", "Normal" },
                gutter = { "bg", "Normal" },
                info = { "fg", "Conditional" },
                scrollbar = { "bg", "Normal" },
                separator = { "fg", "Comment" },
            },
            fzf_opts = {
                ["--info"] = "default",
                ["--layout"] = "reverse-list",
            },
            keymap = {
                builtin = {
                    ["<C-h>"] = "toggle-help",
                    ["<C-p>"] = "toggle-preview",
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    ["alt-t"] = "toggle",
                    ["alt-a"] = "toggle-all",
                },
            },
            winopts = {
                height = 0.7,
                width = 0.55,
                preview = {
                    scrollbar = false,
                    layout = "vertical",
                    vertical = "up:40%",
                },
            },
            global_git_icons = false,
            -- Configuration for specific commands.
            files = {
                winopts = {
                    preview = { hidden = "hidden" },
                },
                actions = {
                    ["ctrl-g"] = actions.toggle_ignore,
                },
            },
            grep = {
                header_prefix = icons.astro.Search .. " ",
            },
            helptags = {
                actions = {
                    -- Open help pages in a vertical split.
                    ["default"] = actions.help_vert,
                },
            },
            lsp = {
                code_actions = {
                    previewer = "codeaction_native",
                },
                symbols = {
                    symbol_icons = icons.ui.BoldArrowRight,
                },
            },
            oldfiles = {
                include_current_session = true,
                winopts = {
                    preview = { hidden = "hidden" },
                },
            },
        }
    end,
    config = function()
        -- calling `setup` is optional for customization
        local fzf_lua = require("fzf-lua")
        fzf_lua.setup({})
    end,
}
