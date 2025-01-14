return {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    event = { "BufReadPost", "BufNewFile" },
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local actions = require("fzf-lua.actions")
        local icons = require("icons")
        return {
            -- Make stuff better combine with the editor.
            fzf_colors = {
                true, -- inherit fzf colors that aren't specified below from
                -- the auto-generated theme similar to `fzf_colors=true`
                ["fg"] = { "fg", "CursorLine" },
                ["bg"] = { "bg", "Normal" },
                ["hl"] = { "fg", "Comment" },
                ["fg+"] = { "fg", "Normal" },
                ["bg+"] = { "bg", "CursorLine" },
                ["hl+"] = { "fg", "Statement" },
                ["info"] = { "fg", "PreProc" },
                ["prompt"] = { "fg", "Conditional" },
                ["pointer"] = { "fg", "Exception" },
                ["marker"] = { "fg", "Keyword" },
                ["spinner"] = { "fg", "Label" },
                ["header"] = { "fg", "Comment" },
                ["gutter"] = "-1",
            },
            fzf_opts = {
                ["--info"] = "default",
                ["--layout"] = "reverse-list",
            },
            keymap = {
                builtin = {
                    true,
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
                fzf = {
                    true,
                    ["ctrl-d"] = "preview-page-down",
                    ["ctrl-u"] = "preview-page-up",
                    ["ctrl-q"] = "select-all+accept",
                },
            },
            actions = {
                files = {
                    true,
                    ["enter"] = actions.file_edit_or_qf,
                    ["ctrl-s"] = actions.file_split,
                    ["ctrl-v"] = actions.file_vsplit,
                    ["ctrl-t"] = actions.file_tabedit,
                    ["alt-q"] = actions.file_sel_to_qf,
                    ["alt-Q"] = actions.file_sel_to_ll,
                },
                buffers = {
                    keymap = { builtin = { ["<C-d>"] = false } },
                    actions = {
                        ["ctrl-x"] = false,
                        ["ctrl-d"] = { actions.buf_del, actions.resume },
                    },
                },
            },
            winopts = {
                height = 0.85,
                width = 0.85,
                border = "single",
                backdrop = 90,
                preview = {
                    border = "single",
                    scrollbar = true,
                    layout = "vertical",
                    vertical = "up:60%",
                },
                on_create = function()
                    vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
                    vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
                end,
            },
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
                    -- previewer = "codeaction_native",
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
    config = function(_, opts)
        -- calling `setup` is optional for customization
        local fzf_lua = require("fzf-lua")
        fzf_lua.setup(opts)
        fzf_lua.register_ui_select()
    end,
}
