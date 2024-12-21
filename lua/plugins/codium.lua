return {}
--[[ return {
    "Exafunction/codeium.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "Codeium" },
    -- cond = not vim.g.vscode,
    cond = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("codeium").setup({
            -- Optionally disable cmp source if using virtual text only
            enable_cmp_source = true,
            virtual_text = {
                enabled = false,

                -- These are the defaults

                -- Set to true if you never want completions to be shown automatically.
                manual = false,
                -- A mapping of filetype to true or false, to enable virtual text.
                filetypes = {},
                -- Whether to enable virtual text of not for filetypes not specifically listed above.
                default_filetype_enabled = true,
                -- How long to wait (in ms) before requesting completions after typing stops.
                idle_delay = 20,
                -- Priority of the virtual text. This usually ensures that the completions appear on top of
                -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
                -- desired.
                virtual_text_priority = 65535,
                -- Set to false to disable all key bindings for managing completions.
                map_keys = true,
                -- The key to press when hitting the accept keybinding but no completion is showing.
                -- Defaults to \t normally or <c-n> when a popup is showing.
                accept_fallback = nil,
                -- Key bindings for managing completions in virtual text mode.
                key_bindings = {
                    -- Accept the current completion.
                    accept = "<M-w>",
                    -- Accept the next word.
                    accept_word = false,
                    -- Accept the next line.
                    accept_line = false,
                    -- Clear the virtual text.
                    clear = false,
                    -- Cycle to the next completion.
                    next = "<M-;>",
                    -- Cycle to the previous completion.
                    prev = "<M-'>",
                },
            },
        })

        local _, vt = pcall(require, "codeium.virtual_text")
        vim.keymap.set(
            { "n", "v" },
            "<F13>ac",
            ":Codeium Chat<cr>",
            { noremap = true, silent = true, desc = "Codeium Chat" }
        )
        -- vim.keymap.set({ "n", "i" }, "<F13>ai", function()
        -- Request completions immediately.
        -- vt.complete()
        -- Request a completion, or cycle to the next if we already have some
        --     vt.cycle_or_complete()
        -- end, { noremap = true, silent = true, desc = "Codeium Complete" })
        -- vim.keymap.set({ "n" }, "<F13>ad", function()
        --     -- Complete only after idle_delay has passed with no other calls to debounced_complete().
        --     vt.debounced_complete()
        -- end, { noremap = true, silent = true, desc = "Codeium Complete After Delay" }),
    end,
} ]]
