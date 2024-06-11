local ts_opts = {
    on_config_done = nil,

    -- A list of parser names, or "all"
    ensure_installed = { "comment", "markdown_inline", "regex", "python", "javascript", "typescript", "lua" },

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    -- A directory to install the parsers into.
    -- By default parsers are installed to either the package dir, or the "site" dir.
    -- If a custom path is used (not nil) it must be added to the runtimepath.
    parser_install_dir = nil,

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable = {},  -- optional, list of language that will be disabled
    },
    highlight = {
        enable = true,                  -- false will disable the whole extension
        disable = function(lang, bufnr) -- Disable in large C++ buffers
            return vim.b.large_buf
        end,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            -- Languages that have a single comment style
            typescript = "// %s",
            css = "/* %s */",
            scss = "/* %s */",
            html = "<!-- %s -->",
            svelte = "<!-- %s -->",
            vue = "<!-- %s -->",
            json = "",
        },
    },
    indent = { enable = true, disable = { "yaml", "python" } },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ['<M-a>'] = "@parameter.inner"
            },
            swap_previous = {
                ['<M-A>'] = "@parameter.inner"
            }
        },
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            including_surrounding_whitespace = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ['al'] = '@loop.outer',
                ['il'] = '@loop.inner',
                -- ['aa'] = '@parameter.outer',
                -- ['ia'] = '@parameter.inner',
                ['id'] = '@conditional.inner',
                ['ad'] = '@conditional.outer',

            },
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V',  -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']c'] = '@class.outer',
                [']sc'] = '@class.inner',

                [']f'] = '@function.outer',  -- outside of the next function
                [']sf'] = '@function.inner', -- inside the start of the next function

                [']l'] = '@loop.outer',
                [']sl'] = '@loop.inner',

                [']d'] = '@conditional.outer',
                [']sd'] = '@conditional.inner',

                -- [']]'] = { query = { '@parameter.inner', '@attribute.inner', '@assignment.outer', '@call.inner',
                --     '@statement.outer', '@function.inner', '@loop.inner', '@return.inner', '@scopename.inner',
                --     '@conditional.inner', } },
                [']]'] = { query = { '@parameter.inner', '@attribute.inner', '@assignment.lhs', '@assignment.rhs' } },
            },
            goto_next_end = {
                [']ec'] = '@class.inner',
                [']ef'] = '@function.inner', -- inside the end of the next function
                [']ed'] = '@conditional.inner',
                [']el'] = '@loop.inner',
            },
            goto_previous_start = {
                ['[c'] = '@class.outer',
                ['[sc'] = '@class.inner',

                ['[f'] = '@function.outer',  -- outside of the previous function
                ['[sf'] = '@function.inner', -- inside the start of the previous function

                ['[l'] = '@loop.outer',
                ['[sl'] = '@loop.inner',

                ['[d'] = '@conditional.outer',
                ['[sd'] = '@conditional.inner',

                -- ['[['] = { query = { '@parameter.inner', '@attribute.inner', '@assignment.outer', '@call.inner',
                --     '@statement.outer', '@function.inner', '@loop.inner', '@return.inner', '@scopename.inner',
                --     '@conditional.inner', } },
                ['[['] = { query = { '@parameter.inner', '@attribute.inner', '@assignment.lhs', '@assignment.rhs' } },
            },
            goto_previous_end = {
                ['[ec'] = '@class.inner',
                ['[ef'] = '@function.inner', -- inside of the end of the previous function
                ['[el'] = '@loop.inner',
                ['[ed'] = '@conditional.inner',

                ['[]'] = "@nothing", -- just to remove default vim keybindings
                [']['] = "@nothing"
            },
        },
    },
    textsubjects = {
        enable = true,
        keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "vn",
            node_incremental = "n",
            node_decremental = "N",
            scope_incremental = "T",
        },
    },
}
-- treesitter config options : END

return ts_opts
