local menu_hl = {
    Class = "ItemMenuClass",
    Interface = "ItemMenuInterface",
    Struct = "ItemMenuStruct",
    Module = "ItemMenuStruct",
    Snippet = "ItemMenuSnippet",
    Method = "ItemMenuMethod",
    Function = "ItemMenuFunction",
    Field = "ItemMenuField",
    Enum = "ItemMenuEnum",
    Variable = "ItemMenuVariable",
    Property = "ItemMenuProperty",
    Keyword = "ItemMenuProperty",
    Value = "ItemMenuValue",
    Text = "ItemMenuText",
    String = "ItemMenuText",
    Unknown = "ItemMenuUnknown",
}

local kind_hl = {
    Class = "ItemKindClass",
    Interface = "ItemKindInterface",
    Struct = "ItemKindStruct",
    Module = "ItemKindStruct",
    Snippet = "ItemKindSnippet",
    Method = "ItemKindMethod",
    Function = "ItemKindFunction",
    Field = "ItemKindField",
    Enum = "ItemKindEnum",
    Variable = "ItemKindVariable",
    Property = "ItemKindProperty",
    Keyword = "ItemKindProperty",
    Value = "ItemKindValue",
    Text = "ItemKindText",
    String = "ItemKindText",
    Unknown = "ItemKindUnknown",
}

local kind_names = {
    spell = "en",
    codeium = "code",
}

local kind_symbol = {
    cody = "󰚩",
    codeium = "󰚩",
    spell = "󰊀",
}

local blink_opts = {
    snippets = { preset = "luasnip" },

    sources = {
        default = {
            "codeium",
            "snippets",
            "lsp",
            "path",
            "buffer",
        },
        -- default = function(ctx)
        --     local default_providers = { "codeium", "lsp", "luasnip", "path", "buffer" }
        --     local valid_files = function()
        --     local ft = { "lua", "python", "html", "css", "scss", "java", "typescript", "javascript", "javascriptreact", "typescriptreact", "json",  }
        --         local file_type = vim.bo.filetype
        --         return vim.tbl_contains(ft, file_type)
        --     end
        --     if vim.bo.filetype == "lua" then
        --         return { "lsp", "lazydev", "luasnip", "path", "buffer" }
        --     elseif valid_files() then
        --         local node = vim.treesitter.get_node()
        --         if node and vim.tbl_contains({ "comment", "line_comment", "block_comment", "string" }, node:type()) then
        --             return { "buffer", "path", "spell" }
        --         else
        --             return default_providers
        --         end
        --     else
        --         return default_providers
        --     end
        -- end,
        per_filetype = {
            sql = { "snippets", "lsp", "dadbod", "buffer", "spell" },
            lua = { "snippets", "lsp", "lazydev", "buffer" },
            norg = { "snippets", "lsp", "buffer", "spell" },
            text = { "lsp", "buffer", "spell" },
            gitcommit = { "lsp", "buffer", "spell" },
            codecompanion = { "codecompanion" },
        },
        providers = {
            -- dont show LuaLS require statements when lazydev has items
            lsp = { fallbacks = { "lazydev" } },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            buffer = {
                name = "Buffer",
                score_offset = -3,
                min_keyword_length = 2, -- Minimum number of characters in the keyword to trigger the provider
                max_items = 8,
                module = "blink.cmp.sources.buffer",
                opts = {
                    -- default to all visible buffers
                    get_bufnrs = function()
                        local open_bufs = vim.iter(vim.api.nvim_list_bufs())
                            :filter(function(buf)
                                return vim.bo[buf].buftype ~= "nofile"
                            end)
                            :totable()
                        --[[ local visible_bufs = vim.iter(vim.api.nvim_list_wins())
                            :map(function(win)
                                return vim.api.nvim_win_get_buf(win)
                            end)
                            :filter(function(buf)
                                return vim.bo[buf].buftype ~= "nofile"
                            end)
                            :totable() ]]
                        return open_bufs
                    end,
                },
            },
            spell = {
                name = "spell",
                module = "blink.compat.source",
                score_offset = -3,
                transform_items = nil, -- Function to transform the items before they're returned
                should_show_items = true, -- Whether or not to show the items
                max_items = 5, -- Maximum number of items to display in the menu
                min_keyword_length = 2, -- Minimum number of characters in the keyword to trigger the provider
                fallbacks = {}, -- If any of these providers return 0 items, it will fallback to this provider
                override = nil, -- Override the source's functions
                opts = {},
            },
            codeium = {
                name = "codeium",
                module = "blink.compat.source",
                score_offset = 3,
                transform_items = nil, -- Function to transform the items before they're returned
                should_show_items = true, -- Whether or not to show the items
                max_items = 5, -- Maximum number of items to display in the menu
                min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
                fallbacks = {}, -- If any of these providers return 0 items, it will fallback to this provider
                override = nil, -- Override the source's functions
                opts = {},
            },
        },
    },

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
        preset = "none",
        ["<M-d>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Esc>"] = { "cancel", "hide", "fallback" },
        ["<M-c>"] = { "hide", "cancel", "fallback" },
        ["<M-s>"] = {
            function(cmp)
                if vim.api.nvim_get_mode().mode == "c" then
                    cmp.show({ providers = { "cmdline", "path" } })
                else
                    -- cmp.show({ providers = { "codeium", "lsp", "snippets", "path", "buffer" } })
                    cmp.show({})
                end
            end,
        },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        --
        -- "super-tab" keymap
        --   you may want to set `completion.trigger.show_in_snippet = false`
        --   or use `completion.list.selection = "manual" | "auto_insert"`
        --
        -- ["<Tab>"] = {
        --     function(cmp)
        --         if cmp.snippet_active() then
        --             return cmp.snippet_forward()
        --         end
        --         -- return cmp.select_next()
        --     end,
        --     "fallback",
        -- },
        -- ["<S-Tab>"] = {
        --     function(cmp)
        --         if cmp.snippet_active() then
        --             return cmp.snippet_backward()
        --         end
        --         -- return cmp.select_prev()
        --     end,
        --     "fallback",
        -- },

        ["<C-n>"] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.snippet_forward()
                else
                    return cmp.select_and_accept()
                end
            end,
            "fallback",
        },

        ["<C-b>"] = { "snippet_backward", "fallback" },

        ["<tab>"] = { "select_next", "fallback" },
        ["<S-tab>"] = { "select_prev", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        --
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        --
        -- "enter" keymap
        --   you may want to set `completion.list.selection = "manual" | "auto_insert"`
        --
        ["<CR>"] = { "accept", "fallback" },
    },

    cmdline = {
        keymap = {
            ["<CR>"] = { "accept_and_enter", "fallback" },

            ["<tab>"] = { "select_next", "fallback" },
            ["<S-tab>"] = { "select_prev", "fallback" },

            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },

            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
        },
    },

    appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    completion = {
        trigger = {
            -- When true, will prefetch the completion items when entering insert mode
            -- WARN: buggy, not recommended unless you'd like to help develop prefetching
            prefetch_on_insert = false,
            -- When false, will not show the completion window automatically when in a snippet
            show_in_snippet = true,
            -- When true, will show the completion window after typing a character that matches the `keyword.regex`
            show_on_keyword = true,
            -- When true, will show the completion window after typing a trigger character
            show_on_trigger_character = true,
            -- LSPs can indicate when to show the completion window via trigger characters
            -- however, some LSPs (i.e. tsserver) return characters that would essentially
            -- always show the window. We block these by default.
            show_on_blocked_trigger_characters = function()
                if vim.api.nvim_get_mode().mode == "c" then
                    return {}
                end

                -- you can also block per filetype, for example:
                -- if vim.bo.filetype == 'markdown' then
                --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
                -- end

                return { " ", "\n", "\t" }
            end,
            -- When both this and show_on_trigger_character are true, will show the completion window
            -- when the cursor comes after a trigger character after accepting an item
            show_on_accept_on_trigger_character = true,
            -- When both this and show_on_trigger_character are true, will show the completion window
            -- when the cursor comes after a trigger character when entering insert mode
            show_on_insert_on_trigger_character = true,
            -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
            -- the completion window when the cursor comes after a trigger character when
            -- entering insert mode/accepting an item
            show_on_x_blocked_trigger_characters = { "'", '"', "(", "{" },
            -- or a function, similar to show_on_blocked_trigger_character
        },
        keyword = {
            -- 'prefix' will fuzzy match on the text before the cursor
            -- 'full' will fuzzy match on the text before *and* after the cursor
            -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
            range = "full",
        },
        list = {
            selection = {
                -- When `true`, will automatically select the first item in the completion list
                preselect = false,
                -- preselect = function(ctx) return ctx.mode ~= 'cmdline' end,

                -- When `true`, inserts the completion item automatically when selecting it
                -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
                -- which will both undo the selection and hide the completion menu
                auto_insert = true,
                -- auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
            },
        },
        -- experimental auto-brackets support
        accept = { auto_brackets = { enabled = true } },
        -- Controls how the completion items are rendered on the popup window
        menu = {
            border = vim.g.win_border,
            winblend = 10,
            -- winhighlight = "Normal:CmpComplitionMenu,FloatBorder:CmpComplitionMenu,CursorLine:CmpSelectedItem,Search:None",
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder,CursorLine:BlinkMenuSelection,Search:Search",
            draw = {
                -- Aligns the keyword you've typed to a component in the menu
                align_to = "label", -- or 'none' to disable
                -- Left and right padding, optionally { left, right } for different padding on each side
                padding = { 0, 1 },
                -- Gap between columns
                gap = 1,
                -- Use treesitter to highlight the label text
                -- treesitter = false,

                -- Components to render, grouped by column
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                    { "source_name" },
                    { "kind" },
                },
                -- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
                -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },

                -- Definitions for possible components to render. Each component defines:
                --   ellipsis: whether to add an ellipsis when truncating the text
                --   width: control the min, max and fill behavior of the component
                --   text function: will be called for each item
                --   highlight function: will be called only when the line appears on screen
                components = {
                    kind_icon = {
                        ellipsis = false,
                        text = function(ctx)
                            local lspkind = require("lspkind")
                            -- return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
                            return " "
                                .. (lspkind.presets.default[ctx.kind] or kind_symbol[ctx.kind] or kind_symbol[string.lower(
                                    ctx.source_name
                                )] or "")
                                .. ctx.icon_gap
                                .. " "
                        end,
                        highlight = function(ctx)
                            -- return (
                            --     require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                            --     or "BlinkCmpKind"
                            -- ) .. ctx.kind
                            return kind_hl[ctx.kind] or "CmpItemKindUnknown"
                        end,
                    },

                    kind = {
                        ellipsis = true,
                        width = { fill = true },
                        text = function(ctx)
                            if ctx.kind == "Unknown" then
                                return kind_names[string.lower(ctx.source_name)] or ctx.kind
                            end
                            return ctx.kind
                        end,
                        highlight = function(ctx)
                            -- return (
                            --     require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                            --     or "BlinkCmpKind"
                            -- ) .. ctx.kind
                            return menu_hl[ctx.kind] or "CmpItemMenuUnknown"
                        end,
                    },

                    label = {
                        ellipsis = true,
                        width = { fill = true, max = 60 },
                        text = function(ctx)
                            return ctx.label .. ctx.label_detail
                        end,
                        highlight = function(ctx)
                            -- label and label details
                            local highlights = {
                                {
                                    0,
                                    #ctx.label,
                                    group = ctx.deprecated and "@keyword.return" or "BlinkCmpLabel",
                                },
                            }
                            if ctx.label_detail then
                                table.insert(highlights, {
                                    #ctx.label,
                                    #ctx.label + #ctx.label_detail,
                                    group = "BlinkCmpLabelDetail",
                                })
                            end

                            -- characters matched on the label by the fuzzy matcher
                            for _, idx in ipairs(ctx.label_matched_indices) do
                                table.insert(highlights, { idx, idx + 1, group = "@function" })
                            end

                            return highlights
                        end,
                    },

                    label_description = {
                        width = { max = 60, min = 10 },
                        text = function(ctx)
                            return ctx.label_description
                        end,
                        highlight = "BlinkCmpGhostText",
                    },

                    source_name = {
                        width = { max = 20, min = 2 },
                        text = function(ctx)
                            return string.lower("[" .. ctx.source_name .. "]")
                        end,
                        highlight = "BlinkCmpGhostText",
                    },
                },
            },
        },

        -- documentation support
        documentation = {
            -- Controls whether the documentation window will automatically show when selecting a completion item
            auto_show = true,
            -- Delay before showing the documentation window
            auto_show_delay_ms = 300,
            -- Delay before updating the documentation window when selecting a new item,
            -- while an existing item is still visible
            update_delay_ms = 50,
            -- Whether to use treesitter highlighting, disable if you run into performance issues
            treesitter_highlighting = true,
            window = {
                min_width = 40,
                max_width = 120,
                max_height = 20,
                border = vim.g.win_border,
                winblend = 10,
                -- winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
                winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
                -- Note that the gutter will be disabled when border ~= 'none'
                scrollbar = true,
                -- Which directions to show the documentation window,
                -- for each of the possible menu window directions,
                -- falling back to the next direction when there's not enough space
                direction_priority = {
                    menu_north = { "e", "w", "n", "s" },
                    menu_south = { "e", "w", "s", "n" },
                },
            },
        },

        -- Displays a preview of the selected item on the current line
        ghost_text = {
            enabled = true,
        },
    },

    -- experimental signature help support
    signature = {
        enabled = true,
        window = {
            min_width = 40,
            max_width = 120,
            max_height = 20,
            border = vim.g.win_border,
            winblend = 10,
            -- winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:FloatBorder",
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder",
            scrollbar = true, -- Note that the gutter will be disabled when border ~= 'none'
            -- Which directions to show the window,
            -- falling back to the next direction when there's not enough space,
            -- or another window is in the way
            direction_priority = { "n", "s" },
            -- Disable if you run into performance issues
            treesitter_highlighting = true,
        },
    },

    fuzzy = {
        -- Allows for a number of typos relative to the length of the query
        -- Set this to 0 to match the behavior of fzf
        max_typos = function(keyword)
            return math.floor(#keyword / 5)
        end,
        -- Frecency tracks the most recently/frequently used items and boosts the score of the item
        use_frecency = false,
        -- Proximity bonus boosts the score of items matching nearby words
        use_proximity = true,
        -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
        -- You may pass a function instead of a string to customize the sorting
        sorts = { "score", "sort_text" },
    },
}

return {
    {
        "saghen/blink.cmp",
        event = { "BufReadPost", "BufNewFile" },
        version = "*",
        cond = not vim.g.vscode,
        -- build = "cargo build --release",
        dependencies = {
            { "L3MON4D3/LuaSnip", cond = not vim.g.vscode },
            { "rafamadriz/friendly-snippets", event = "VeryLazy", cond = not vim.g.vscode },
            { "f3fora/cmp-spell", event = "VeryLazy", cond = not vim.g.vscode },
            { "saghen/blink.compat", event = "VeryLazy", cond = not vim.g.vscode, opts = {} },
        },
        opts = blink_opts,
        opts_extend = {
            "sources.default",
            "sources.compat",
            "sources.default",
        },
    },
}
