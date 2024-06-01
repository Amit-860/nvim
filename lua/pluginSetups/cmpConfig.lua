local cmp = require('cmp')
local cmp_mapping = require "cmp.config.mapping"
local luasnip = require("luasnip")
local lspkind = require('lspkind')
local cmp_types = require("cmp.types.cmp")
local ConfirmBehavior = cmp_types.ConfirmBehavior
local SelectBehavior = cmp_types.SelectBehavior
local compare = require('cmp.config.compare')

vim.api.nvim_set_hl(0, "CmpItemMenu", { italic = true })
-- vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true, reverse = true })
vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true, })
vim.api.nvim_set_hl(0, "CmpComplitionMenu", { bg = "#202d3f" })

vim.api.nvim_set_hl(0, "CmpItemKindClass", { bg = "#ff5c52", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { bg = "#ff5c52", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { bg = "#59b9ff", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { bg = "#86abdc", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "#afafff", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindField", { bg = "#7ad5d6", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "#dfdfe0", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { bg = "#cfa333", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { bg = "#81b29a", fg = "#131a24" })


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
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local source_icon = {
    luasnip = "snip",
    nvim_lsp = "lsp",
    nvim_lua = 'lsp',
    nvim_lsp_signature_help = 'lsp',
    nvim_lsp_document_symbol = 'lsp',
    path = 'path',
    treesitter = 'TS',
    buffer = 'buff'
}

local cmp_opts = {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },

    window = {
        completion = {
            -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:@comment.note,Search:None",
            winhighlight =
            "Normal:CmpComplitionMenu,FloatBorder:CmpComplitionMenu,CursorLine:CmpSelectedItem,Search:None",
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
            local ellipses_char = '…'

            -- vim_item.kind = (icons[vim_item.kind] or "?") .. " " .. vim_item.kind             -- for icon without matching color label
            -- vim_item.kind = (icons[vim_item.kind] or "?") .. " "                              -- for icon without label
            -- vim_item.kind = " " .. lspkind.presets.default[kind] .. " " .. kind
            vim_item.kind = " " .. lspkind.presets.default[kind] .. " "

            -- vim_item.menu = " (" .. kind .. ")"

            local source = entry.source.name


            --removing dubplicates
            if source == "luasnip" or source == "nvim_lsp" then
                vim_item.dup = 0
            end

            -- vim_item.menu = "[" .. (source_icon[source] or source) .. "]"
            vim_item.menu = kind

            -- trims down the extra long suggestions
            local function trim(text)
                local max = 40
                if text and text:len() > max then
                    text = text:sub(1, max) .. ellipses_char
                end
                return text
            end

            vim_item.abbr = trim(vim_item.abbr) .. " "

            return vim_item
        end
    },

    confirm_opts = {
        behavior = ConfirmBehavior.Replace,
        select = true,
    },

    experimental = {
        ghost_text = true,
    },

    mapping = cmp_mapping.preset.insert({
        ["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
        ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item { behavior = SelectBehavior.Select }, { "i" }),
        ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item { behavior = SelectBehavior.Select }, { "i" }),
        ["<C-d>"] = cmp_mapping.scroll_docs(-4),
        ["<C-f>"] = cmp_mapping.scroll_docs(4),
        ["<C-l>"] = cmp_mapping(function()
            cmp.complete()
        end, { "i" }),
        ["<C-y>"] = cmp_mapping {
            i = cmp_mapping.confirm { behavior = ConfirmBehavior.Replace, select = false },
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm { behavior = ConfirmBehavior.Replace, select = false }
                else
                    fallback()
                end
            end,
        },
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
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
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),


    sources = cmp.config.sources({
            { name = 'luasnip' }, -- For luasnip users.
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'nvim_lsp_document_symbol' },
            { name = 'path' },
            { name = 'treesitter' },
        },
        {
            {
                name = 'buffer',
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end
                }
            },
        }
    ),

    sorting = {
        comparators = {
            compare.exact,
            compare.recently_used,
            -- compare.length,
        }
    }
}


if vim.g.neovide then
    cmp_opts.window = {
        completion = nil,
        documentation = nil
    }
end

cmp.setup(cmp_opts)

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup()


-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
