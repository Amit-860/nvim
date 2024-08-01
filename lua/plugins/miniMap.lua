return {
    "gorbit99/codewindow.nvim",
    events = { "BufReadPost", "BufNewFile" },
    opts = {
        active_in_terminals = false, -- Should the minimap activate for terminal buffers
        auto_enable = true, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
        exclude_filetypes = { "help", "noice", "NeogitStatus", "TelescopePrompt", "NvimTree", "dashboard" }, -- Choose certain filetypes to not show minimap on
        max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
        max_lines = 2000, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
        minimap_width = 16, -- The width of the text part of the minimap
        use_lsp = true, -- Use the builtin LSP to show errors and warnings
        use_treesitter = true, -- Use nvim-treesitter to highlight the code
        use_git = true, -- Show small dots to indicate git additions and deletions
        width_multiplier = 3, -- How many characters one dot represents
        z_index = 1000, -- The z-index the floating window will be on
        show_cursor = true, -- Show the cursor position in the minimap
        screen_bounds = "lines", -- How the visible area is displayed, "lines": lines above and below, "background": background color
        window_border = "none", -- The border style of the floating window (accepts all usual options)
        relative = "win", -- What will be the minimap be placed relative to, "win": the current window, "editor": the entire editor
        events = { "TextChanged", "DiagnosticChanged", "FileWritePost" }, -- Events that update the code window
    },
    keys = function()
        local codewindow = require("codewindow")
        -- codewindow.open_minimap()
        -- codewindow.close_minimap()
        -- codewindow.toggle_minimap()
        -- codewindow.toggle_focus()
        return {
            vim.keymap.set("n", "<F3>mo", function()
                codewindow.open_minimap()
            end, { desc = "Minimap Open" }),
            vim.keymap.set("n", "<F3>mc", function()
                codewindow.close_minimap()
            end, { desc = "Minimap Close" }),
            vim.keymap.set("n", "<F3>mm", function()
                codewindow.toggle_minimap()
            end, { desc = "Minimap Toggle" }),
            vim.keymap.set("n", "<F3>mf", function()
                codewindow.toggle_focus()
            end, { desc = "Minimap focus" }),
        }
    end,
    config = function(_, opts)
        local codewindow = require("codewindow")
        codewindow.setup(opts)
        vim.api.nvim_set_hl(0, "CodewindowBorder", { fg = "#aeaeae" })
    end,
}
