local menu_hl = {
    Class = "ItemMenuClass",
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
    snippets = {
        expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
            if filter and filter.direction then
                return require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
        end,
        jump = function(direction)
            require("luasnip").jump(direction)
        end,
    },

    sources = {
        completion = {
            enabled_providers = {
                "codeium",
                "lsp",
                "luasnip",
                "path",
                "buffer",
                "lazydev",
                "dadbod",
                "spell",
            },
        },
        providers = {
            -- dont show LuaLS require statements when lazydev has items
            lsp = { fallback_for = { "lazydev" }, max_items = 5 },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            spell = {
                name = "spell",
                module = "blink.compat.source",
                score_offset = -3,
                transform_items = nil, -- Function to transform the items before they're returned
                should_show_items = true, -- Whether or not to show the items
                max_items = 5, -- Maximum number of items to display in the menu
                min_keyword_length = 3, -- Minimum number of characters in the keyword to trigger the provider
                fallback_for = {}, -- If any of these providers return 0 items, it will fallback to this provider
                override = nil, -- Override the source's functions
                opts = {},
            },
            codeium = {
                name = "codeium",
                module = "blink.compat.source",
                score_offset = 5,
                transform_items = nil, -- Function to transform the items before they're returned
                should_show_items = true, -- Whether or not to show the items
                max_items = 5, -- Maximum number of items to display in the menu
                min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
                fallback_for = {}, -- If any of these providers return 0 items, it will fallback to this provider
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
        preset = "default",
        ["<M-d>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        --
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        --
        -- "super-tab" keymap
        --   you may want to set `completion.trigger.show_in_snippet = false`
        --   or use `completion.list.selection = "manual" | "auto_insert"`
        --
        ["<Tab>"] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.snippet_forward()
                else
                    return cmp.select_next()
                end
            end,
            "fallback",
        },
        ["<S-Tab>"] = {

            function(cmp)
                if cmp.snippet_active() then
                    return cmp.snippet_backward()
                else
                    return cmp.select_prev()
                end
            end,
            "fallback",
        },
        --
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        --
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        --
        -- "enter" keymap
        --   you may want to set `completion.list.selection = "manual" | "auto_insert"`
        --
        ["<CR>"] = { "accept", "fallback" },
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
            show_in_snippet = false,
        },
        list = {
            selection = "manual",
            -- Controls how the completion items are selected
            -- 'preselect' will automatically select the first item in the completion list
            -- 'manual' will not select any item by default
            -- 'auto_insert' will not select any item by default, and insert the completion items automatically
            -- when selecting them
        },
        -- experimental auto-brackets support
        accept = { auto_brackets = { enabled = true } },
        -- Controls how the completion items are rendered on the popup window
        menu = {
            border = "single",
            winblend = 10,
            -- winhighlight = "Normal:CmpComplitionMenu,FloatBorder:CmpComplitionMenu,CursorLine:CmpSelectedItem,Search:None",
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            draw = {
                -- Aligns the keyword you've typed to a component in the menu
                align_to_component = "label", -- or 'none' to disable
                -- Left and right padding, optionally { left, right } for different padding on each side
                padding = 0,
                -- Gap between columns
                gap = 1,
                -- Use treesitter to highlight the label text
                treesitter = false,

                -- Components to render, grouped by column
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                    { "kind" },
                    { "source_name" },
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
                                    group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
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
                                table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                            end

                            return highlights
                        end,
                    },

                    label_description = {
                        width = { max = 30 },
                        text = function(ctx)
                            return ctx.label_description
                        end,
                        highlight = "BlinkCmpLabelDescription",
                    },

                    source_name = {
                        width = { max = 30 },
                        text = function(ctx)
                            return string.lower(ctx.source_name) .. " "
                        end,
                        highlight = "BlinkCmpSource",
                    },
                },
            },
        },

        -- documentation support
        documentation = {
            -- Controls whether the documentation window will automatically show when selecting a completion item
            auto_show = true,
            -- Delay before showing the documentation window
            auto_show_delay_ms = 1000,
            -- Delay before updating the documentation window when selecting a new item,
            -- while an existing item is still visible
            update_delay_ms = 150,
            -- Whether to use treesitter highlighting, disable if you run into performance issues
            treesitter_highlighting = true,
            window = {
                min_width = 10,
                max_width = 60,
                max_height = 20,
                border = "single",
                winblend = 10,
                winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
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
            enabled = false,
        },
    },

    -- experimental signature help support
    signature = { enabled = true },
}

return {
    {
        "saghen/blink.cmp",
        event = { "UIEnter" },
        version = "v0.*",
        dependencies = {
            { "L3MON4D3/LuaSnip", event = "VeryLazy", cond = not vim.g.vscode },
            { "rafamadriz/friendly-snippets", event = "VeryLazy", cond = not vim.g.vscode },
            {
                "f3fora/cmp-spell",
                ft = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown", "NeogitCommitMessage" },
                cond = not vim.g.vscode,
            },
        },
        opts = blink_opts,
        -- allows extending the enabled_providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.completion.enabled_providers" },
    },
    {
        "saghen/blink.compat",
        event = { "VeryLazy" },
        opts = {},
    },
}
