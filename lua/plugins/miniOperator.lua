return {
    "echasnovski/mini.operators",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        -- Each entry configures one operator.
        -- `prefix` defines keys mapped during `setup()`: in Normal mode
        -- to operate on textobject and line, in Visual - on selection.

        -- Evaluate text and replace with output
        evaluate = {
            prefix = "g=",

            -- Function which does the evaluation
            func = nil,
        },

        -- Exchange text regions
        exchange = {
            prefix = "gz",

            -- Whether to reindent new text to match previous indent
            reindent_linewise = true,
        },

        -- Multiply (duplicate) text
        multiply = {
            prefix = "gm",

            -- Function which can modify text before multiplying
            func = nil,
        },

        -- Replace text with register
        replace = {
            prefix = "gr",

            -- Whether to reindent new text to match previous indent
            reindent_ligewise = true,
        },

        -- Sort text
        sort = {
            prefix = "gS",

            -- Function which does the sort
            func = nil,
        },
    },
}
