require("noice").setup({
    lsp = {
        progress = { enabled = true, },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = true, },
        hover = { enabled = true, },
        message = { enabled = true, },
    },
    -- routes = {
    --     enabled = true,
    --     { view = "cmdline", filter = { event = "msg_showmode" } }
    -- },
    presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
    notify = { enabled = true, },
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
                row = math.floor(vim.o.lines * 0.80),
                -- col = math.floor(vim.o.columns * 0.35),
                col = '50%'
            },
            -- position = {
            --     row = 10,
            --     col = "50%"
            -- },
            size = {
                width = '30%',
            },
        },
    },
})
