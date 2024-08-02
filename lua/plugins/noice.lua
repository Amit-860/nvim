return {
    "folke/noice.nvim",
    event = "VeryLazy",
    version = "4.4.7",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = function()
        local lazy_opts = {
            lsp = {
                progress = { enabled = true },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                signature = { enabled = true },
                hover = {
                    enabled = false,
                    opts = {},
                },
                message = { enabled = true },
            },
            -- routes = {
            --     enabled = true,
            --     { view = "cmdline", filter = { event = "msg_showmode" } }
            -- },
            presets = {
                bottom_search = false, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                lsp_doc_border = false, -- add a border to hover docs and signature help
            },
            notify = { enabled = false },
            win_options = {
                winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
            },
            views = {
                cmdline_popup = {
                    border = { style = "single", padding = { 0, 1 } },
                    filter_options = {},
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                    -- relative = "win",
                    position = {
                        row = math.floor(vim.o.lines * 0.22),
                        -- col = math.floor(vim.o.columns * 0.35),
                        col = "50%",
                    },
                    -- position = {
                    --     row = 10,
                    --     col = "50%"
                    -- },
                    size = {
                        width = "45%",
                    },
                },
                hover = {
                    relative = "cursor",
                    border = { style = "single", padding = { 0, 1 } },
                    position = {
                        row = 2,
                        col = 0,
                    },
                    close = {
                        events = {
                            "CursorMoved",
                            "BufHidden",
                            "InsertCharPre",
                            "WinLeave",
                            "InsertEnter",
                            "InsertLeave",
                        },
                        keys = { "<ESC>", "q" },
                    },
                },
                mini = {
                    backend = "mini",
                    zindex = 900,
                },
            },
        }

        return lazy_opts
    end,
}
