return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {},
        opts = function()
            local cmp = require("cmp")
            local cmp_mapping = require("cmp.config.mapping")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local cmp_types = require("cmp.types.cmp")
            local ConfirmBehavior = cmp_types.ConfirmBehavior
            local SelectBehavior = cmp_types.SelectBehavior
            local compare = require("cmp.config.compare")

            local function jumpable(dir)
                local win_get_cursor = vim.api.nvim_win_get_cursor
                local get_current_buf = vim.api.nvim_get_current_buf

                ---sets the current buffer's luasnip to the one nearest the cursor
                ---@return boolean true if a node is found, false otherwise
                local function seek_luasnip_cursor_node()
                    -- TODO(kylo252): upstream this
                    -- for outdated versions of luasnip
                    if not luasnip.session.current_nodes then
                        return false
                    end

                    local node = luasnip.session.current_nodes[get_current_buf()]
                    if not node then
                        return false
                    end

                    local snippet = node.parent.snippet
                    local exit_node = snippet.insert_nodes[0]

                    local pos = win_get_cursor(0)
                    pos[1] = pos[1] - 1

                    -- exit early if we're past the exit node
                    if exit_node then
                        local exit_pos_end = exit_node.mark:pos_end()
                        if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
                            snippet:remove_from_jumplist()
                            luasnip.session.current_nodes[get_current_buf()] = nil

                            return false
                        end
                    end

                    node = snippet.inner_first:jump_into(1, true)
                    while node ~= nil and node.next ~= nil and node ~= snippet do
                        local n_next = node.next
                        local next_pos = n_next and n_next.mark:pos_begin()
                        local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
                            or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

                        -- Past unmarked exit node, exit early
                        if n_next == nil or n_next == snippet.next then
                            snippet:remove_from_jumplist()
                            luasnip.session.current_nodes[get_current_buf()] = nil

                            return false
                        end

                        if candidate then
                            luasnip.session.current_nodes[get_current_buf()] = node
                            return true
                        end

                        local ok
                        ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
                        if not ok then
                            snippet:remove_from_jumplist()
                            luasnip.session.current_nodes[get_current_buf()] = nil

                            return false
                        end
                    end

                    -- No candidate, but have an exit node
                    if exit_node then
                        -- to jump to the exit node, seek to snippet
                        luasnip.session.current_nodes[get_current_buf()] = snippet
                        return true
                    end

                    -- No exit node, exit from snippet
                    snippet:remove_from_jumplist()
                    luasnip.session.current_nodes[get_current_buf()] = nil
                    return false
                end

                if dir == -1 then
                    return luasnip.in_snippet() and luasnip.jumpable(-1)
                else
                    return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
                end
            end

            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local cmp_confirm = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            })

            -- don't confirm for signature help to allow new line without selecting argument name
            local confirm = cmp.sync(function(fallback)
                local e = cmp.core.view:get_selected_entry()
                if e and e.source.name == "nvim_lsp_signature_help" then
                    fallback()
                else
                    cmp_confirm(fallback)
                end
            end)

            local cmp_opts = {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },

                window = {
                    completion = {
                        winhighlight = "Normal:CmpComplitionMenu,FloatBorder:CmpComplitionMenu,CursorLine:CmpSelectedItem,Search:None",
                        -- border = 'single',
                        col_offset = -3,
                        side_padding = 0,
                    },
                    documentation = {
                        winhighlight = "Normal:CmpComplitionMenu,FloatBorder:CmpComplitionMenu,Search:None",
                        -- border = 'single',
                    },
                },

                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind = vim_item.kind
                        local ellipses_char = "…"

                        -- vim_item.kind = (icons[vim_item.kind] or "?") .. " " .. vim_item.kind             -- for icon without matching color label
                        -- vim_item.kind = (icons[vim_item.kind] or "?") .. " "                              -- for icon without label
                        -- vim_item.kind = " " .. lspkind.presets.default[kind] .. " " .. kind

                        --setting cmp menu kind icons
                        if not kind then
                            kind = "Unknown"
                            vim_item.kind = " " .. "?" .. " "
                        else
                            vim_item.kind = " " .. (lspkind.presets.default[kind] or "") .. " "
                        end

                        --removing dubplicates
                        local source = entry.source.name
                        if source == "luasnip" or source == "nvim_lsp" then
                            vim_item.dup = 0
                        end

                        local source_symbol = {
                            nvim_lsp = "lsp",
                            buffer = "buff",
                            luasnip = "snip",
                            nvim_lsp_signature_help = "sign",
                            nvim_lua = "lsp",
                            ["vim-dadbod-completion"] = "db",
                            treesitter = "ts",
                            spell = "en",
                            async_path = "path",
                        }

                        -- setting cmp menu
                        -- vim_item.menu = " (" .. kind .. ")"
                        -- vim_item.menu = string.lower(kind)
                        -- vim_item.menu = "[" .. (source_icon[source] or source) .. "]"
                        -- vim_item.menu = string.lower(kind) .. " ⟨" .. (source_symbol[source] or source) .. "⟩"
                        local padding = function()
                            local rep = 10 - #kind
                            if rep < 1 then
                                return " "
                            end
                            return string.rep(" ", rep)
                        end
                        vim_item.menu = string.lower(kind) .. padding() .. string.lower(source_symbol[source] or source)

                        -- trims down the extra long suggestions
                        -- trmming and setting menu and abbr
                        local widths = {
                            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
                        }

                        for key, width in pairs(widths) do
                            if vim_item[key] and vim.fn.strdisplaywidth(vim_item[key]) > width then
                                vim_item[key] = vim.fn.strcharpart(vim_item[key], 0, width - 1) .. ellipses_char
                            end
                        end

                        vim_item.menu_hl_group = ({
                            Class = "CmpItemMenuClass",
                            Struct = "CmpItemMenuStruct",
                            Snippet = "CmpItemMenuSnippet",
                            Method = "CmpItemMenuMethod",
                            Function = "CmpItemMenuFunction",
                            Field = "CmpItemMenuField",
                            Enum = "CmpItemMenuEnum",
                            Variable = "CmpItemMenuVariable",
                            Value = "CmpItemMenuValue",
                            Text = "CmpItemMenuText",
                            String = "CmpItemMenuText",
                            Unknown = "CmpItemMenuUnknown",
                        })[kind] or "CmpItemMenuUnknown"

                        vim_item.kind_hl_group = ({
                            Class = "CmpItemKindClass",
                            Struct = "CmpItemKindStruct",
                            Snippet = "CmpItemKindSnippet",
                            Method = "CmpItemKindMethod",
                            Function = "CmpItemKindFunction",
                            Field = "CmpItemKindField",
                            Enum = "CmpItemKindEnum",
                            Variable = "CmpItemKindVariable",
                            Value = "CmpItemKindValue",
                            Text = "CmpItemKindText",
                            String = "CmpItemKindText",
                            Unknown = "CmpItemKindUnknown",
                        })[kind] or "CmpItemKindUnknown"

                        return vim_item
                    end,
                },

                completion = {
                    keyword_length = 1,
                },

                confirm_opts = {
                    behavior = ConfirmBehavior.Replace,
                    select = true,
                },

                experimental = {
                    ghost_text = true,
                },

                mapping = cmp_mapping.preset.insert({
                    ["<C-k>"] = cmp_mapping(
                        cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }),
                        { "i", "c" }
                    ),
                    ["<C-j>"] = cmp_mapping(
                        cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }),
                        { "i", "c" }
                    ),
                    ["<Down>"] = cmp_mapping(
                        cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }),
                        { "i" }
                    ),
                    ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
                    ["<C-d>"] = cmp_mapping.scroll_docs(-4),
                    ["<C-u>"] = cmp_mapping.scroll_docs(4),
                    ["<C-l>"] = cmp_mapping(function()
                        cmp.complete()
                    end, { "i" }),
                    ["<C-y>"] = cmp_mapping({
                        i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
                        c = function(fallback)
                            if cmp.visible() then
                                cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                    }),
                    -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<CR>"] = confirm,
                    ["<tab>"] = cmp_mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior, count = 1 })
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif jumpable(1) then
                            luasnip.jump(1)
                            -- elseif has_words_before() then
                            -- cmp.complete()
                            -- fallback()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp_mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior, count = 1 })
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "cody" },
                    { name = "luasnip" },
                    {
                        name = "lazydev",
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    },
                    { name = "nvim_lsp" },
                    -- { name = 'nvim_lsp_signature_help' },
                    { name = "nvim_lua" },
                    -- { name = 'path' },
                    { name = "async_path" },
                    { name = "treesitter", keyword_length = 3 },
                }, {
                    {
                        name = "buffer",
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end,
                        },
                        keyword_length = 3,
                    },
                }),

                sorting = {
                    comparators = {
                        compare.offset,
                        -- compare.exact,
                        compare.score,
                        compare.recently_used,
                        compare.kind,
                        compare.sort_text,
                        compare.length,
                        compare.order,
                    },
                },
            }

            local border = function()
                if vim.g.transparency or vim.g.neovide then
                    return "none"
                end
                return "single"
            end
            cmp_opts.window.completion.border = border()
            cmp_opts.window.documentation.border = border()

            return cmp_opts
        end,
        config = function(_, opts)
            local cmp = require("cmp")

            cmp.setup(opts)

            -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
            -- Set configuration for specific filetype.
            cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
                sources = {
                    -- { name = 'git' },
                    { name = "buffer" },
                    { name = "treesitter" },
                },
            })
            -- local cmp_git = pcall(require, "cmp_git")
            -- if cmp_git then require("cmp_git").setup() end

            cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
                sources = cmp.config.sources({
                    { name = "luasnip" },
                    { name = "cmp-dbee" },
                }, {
                    { name = "buffer", keyword_length = 3 },
                }),
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                }),
            })

            -- for vim.ui.input completion support
            cmp.setup.cmdline("@", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                }),
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = {
                    disallow_symbol_nonprefix_matching = false,
                    disallow_fullfuzzy_matching = false,
                    disallow_fuzzy_matching = false,
                    disallow_partial_fuzzy_matching = false,
                    disallow_partial_matching = false,
                    disallow_prefix_unmatching = false,
                },
            })

            cmp.setup.filetype({ "*.txt", "*.tex", "*.typ", "gitcommit", "markdown", "NeogitCommitMessage" }, {
                sources = {
                    { name = "buffer" },
                    {
                        name = "spell",
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                            preselect_correct_word = true,
                        },
                    },
                    { name = "treesitter" },
                },
            })

            cmp.setup.filetype({ "norg" }, {
                sources = {
                    { name = "neorg" },
                    { name = "buffer" },
                    {
                        name = "spell",
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                            preselect_correct_word = true,
                        },
                    },
                    { name = "treesitter" },
                },
            })

            cmp.setup.filetype({ "NvimTree" }, {
                enabled = false,
            })
        end,
    },
    -- { 'ray-x/cmp-treesitter',                                 event = { "VeryLazy" } },
    {
        "hrsh7th/cmp-nvim-lsp",
        event = { "LspAttach" },
    },
    {
        "hrsh7th/cmp-buffer",
        event = { "BufReadPost", "BufNewFile" },
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { "VeryLazy" },
    },
    {
        url = "https://codeberg.org/FelipeLema/cmp-async-path",
        event = { "VeryLazy" },
    },
    {
        "f3fora/cmp-spell",
        ft = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown", "NeogitCommitMessage" },
        -- event = { "BufReadPost", "BufNewFile" }
    },
    {
        "saadparwaiz1/cmp_luasnip",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = "L3MON4D3/LuaSnip",
    },
    {
        "MattiasMTS/cmp-dbee",
        opts = {},
        ft = "sql",
    },
}
