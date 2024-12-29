return {
    "echasnovski/mini.surround",
    event = { "VeryLazy" },
    version = "*",
    opts = function()
        return {
            -- Add custom surroundings to be used on top of builtin ones. For more
            -- information with 'examples', see `:h MiniSurround.config`.
            custom_surroundings = nil,

            -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
            highlight_duration = 500,

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                add = "ys", -- Add surrounding in Normal and Visual modes
                delete = "yd", -- Delete surrounding
                find = "yf", -- Find surrounding (to the right)
                find_left = "yF", -- Find surrounding (to the left)
                highlight = "yh", -- Highlight surrounding
                replace = "yr", -- Replace surrounding
                update_n_lines = "yn", -- Update `n_lines`

                suffix_last = "p", -- Suffix to search with "prev" method
                suffix_next = "n", -- Suffix to search with "next" method
            },

            -- Number of lines within which surrounding is searched
            n_lines = 20,

            -- Whether to respect selection type:
            -- - Place surroundings on separate lines in linewise mode.
            -- - Place surroundings on each line in blockwise mode.
            respect_selection_type = false,

            -- How to search for surrounding (first inside current line, then inside
            -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
            -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
            -- see `:h MiniSurround.config`.
            search_method = "cover",

            -- Whether to disable showing non-error feedback
            -- This also affects (purely informational) helper messages shown after
            -- idle time if user input is required.
            silent = false,
        }
    end,
}
