return {
    "folke/which-key.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    -- keys = { "<leader>", "<SPC>", " ", "<F13>" },
    opts = {
        ---@type false | "classic" | "modern" | "helix"
        preset = "helix",
        -- Delay before showing the popup. Can be a number or a function that returns a number.
        ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
        delay = function(ctx)
            return ctx.plugin and 0 or 300
        end,
        --- You can add any mappings here, or use `require('which-key').add()` later
        ---@type wk.Spec
        spec = {},
        -- show a warning when issues were detected with your mappings
        notify = true,
        -- Enable/disable WhichKey for certain mapping modes
        defer = function(ctx)
            return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
        end,
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            presets = {
                operators = true, -- adds help for operators like d, y, ...
                motions = true, -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
        win = {
            -- width = 1,
            height = { min = 4, max = 24 },
            -- col = 0,
            row = -1,
            border = "single",
            no_overlap = false,
            padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
            title = false,
            title_pos = "center",
            zindex = 1000,
            -- Additional vim.wo and vim.bo options
            bo = {},
            wo = {
                -- winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
            },
        },
        layout = {
            width = { min = 20 }, -- min and max width of the columns
            spacing = 5, -- spacing between columns
            align = "center", -- align columns left, center or right
        },
        keys = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },
        ---@type (string|wk.Sorter)[]
        --- Add "manual" as the first element to use the order the mappings were registered
        --- Other sorters: "desc"
        sort = { "local", "order", "group", "alphanum", "mod", "lower", "icase" },
        expand = 1, -- expand groups when <= n mappings
        ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
        replace = {
            key = {
                function(key)
                    return require("which-key.view").format(key)
                end,
                { "<space>", "SPC" },
                { "<cr>", "RET" },
                { "<tab>", "TAB" },
            },
            desc = {
                { "<Plug>%((.*)%)", "%1" },
                { "^%+", "" },
                { "<[cC]md>", "" },
                { "<[cC][rR]>", "" },
                { "<[sS]ilent>", "" },
                { "^lua%s+", "" },
                { "^call%s+", "" },
                { "^:%s*", "" },
            },
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
            ellipsis = "…",
            --- See `lua/which-key/icons.lua` for more details
            --- Set to `false` to disable keymap icons
            ---@type wk.IconRule[]|false
            rules = {},
            mappings = true,
            -- use the highlights from mini.icons
            -- When `false`, it will use `WhichKeyIcon` instead
            colors = true,
            -- used by key format
            keys = {
                Up = " ",
                Down = " ",
                Left = " ",
                Right = " ",
                C = "󰘴 ",
                M = "󰘵 ",
                D = "󰘳 ",
                S = "󰘶 ",
                CR = "󰌑 ",
                Esc = "󱊷 ",
                ScrollWheelDown = "󱕐 ",
                ScrollWheelUp = "󱕑 ",
                NL = "󰌑 ",
                BS = "󰁮",
                Space = "󱁐 ",
                Tab = "󰌒 ",
                F1 = "󱊫",
                F2 = "󱊬",
                F13 = "󱊭",
                F4 = "󱊮",
                F5 = "󱊯",
                F6 = "󱊰",
                F7 = "󱊱",
                F8 = "󱊲",
                F9 = "󱊳",
                F10 = "󱊴",
                F11 = "󱊵",
                F12 = "󱊶",
            },
        },
        show_help = true, -- show a help message in the command line for using WhichKey
        show_keys = true, -- show the currently pressed key and its label as a message in the command line
        -- Which-key automatically sets up triggers for your mappings.
        -- But you can disable this and setup the triggers yourself.
        -- Be aware, that triggers are not needed for visual and operator pending mode.
        triggers = {
            { "<auto>", mode = "nixsotc" },
            { "m", mode = "n" },
        },
        disable = {
            -- disable WhichKey for certain buf types and file types.
            ft = {},
            bt = {},
        },
        debug = false, -- enable wk.log in the current directory
    },
    config = function(_, opts)
        local icons = require("icons")
        local which_key = require("which-key")

        if vim.g.neovide then
            opts.win.wo.winblend = 75
        end

        which_key.setup(opts)

        which_key.add({
            { "<leader>p", desc = "Project", icon = icons.ui.Project },
            { "<leader>D", group = "Debug" },
            { "<leader>Db", group = "Breakpoints", icon = icons.astro.Debugger },
            { "<leader>L", group = "LeetCode" },
            { "<leader>P", group = "Plugins", icon = icons.ui.Package },
            { "<leader>S", group = "Session" },
            { "<leader>s", group = "Surround", icon = icons.ui.Surround },
            { "<leader>;", group = "Dropbar", icon = icons.ui.Map },
            { "<leader>e", group = "Explorer", icon = icons.ui.List },
            { "<leader>c", group = "Cursor", icon = "󰗧" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>m", group = "Grapple", icon = icons.ui.Watches },
            { "<leader>l", group = "LSP", icon = icons.astro.ActiveLSP },
            { "<leader>lt", group = "Test", icon = icons.astro.LSPLoading1 },
            { "<leader>n", group = "Notes", icon = icons.ui.Note },
            { "<leader>o", group = "Others", icon = icons.kind.Number },
            { "<leader>q", group = "Quit" },
            { "<leader>u", name = "Undo", icon = icons.ui.Undo },
            { "<leader>z", desc = "Zoxide", icon = icons.ui.FolderSymlink },
            { "<leader>/", desc = "which_key_ignore", icon = icons.ui.Comment },
            { "<leader>r", desc = "Replace", icon = "" },
            { "<leader>le", desc = "Diagnostics", icon = icons.diagnostics.Information },
            { "<leader>lE", desc = "Project Diagnostics", icon = icons.diagnostics.Information },
            { "<F13>c", desc = "Conform", icon = icons.astro.FolderClosed },
            { "<F13>a", desc = "Cody", icon = icons.misc.Robot },
            { "<F13>s", desc = "Spectre", icon = icons.misc.Robot },
            { "<F13>t", desc = "Toggle", icon = icons.astro.Selected },
            { "<F13>g", desc = "Git", icon = icons.astro.GitBranch },
            { "<F13>o", desc = "Oil", icon = icons.astro.FolderEmpty },
            { "<F13>d", desc = "Dadbod", icon = icons.astro.FileNew },
        })
    end,
}
