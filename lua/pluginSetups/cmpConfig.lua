local cmp = require('cmp')
local cmp_mapping = require "cmp.config.mapping"
local luasnip = require("luasnip")
local lspkind = require('lspkind')
local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
local ConfirmBehavior = cmp_types.ConfirmBehavior
local SelectBehavior = cmp_types.SelectBehavior



local function jumpable(dir)
    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if not luasnip_ok then
        return false
    end

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

local cmp_opts = {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = 0,
            side_padding = 0,
        },
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        formatting = {
            format = lspkind.cmp_format {
                mode = 'symbol_text',
                -- The function below will be called before any actual modifications
                -- from lspkind so that you can provide more controls on popup
                -- customization.
                -- (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function(_, vim_item)
                    -- set max width of cmp window
                    local width = 30
                    local ellipses_char = '…'
                    local label = vim_item.abbr
                    local truncated_label = vim.fn.strcharpart(label, 0, width)
                    if truncated_label ~= label then
                        vim_item.abbr = truncated_label .. ellipses_char
                    else
                        vim_item.abbr = label .. ' '
                    end
                    return vim_item
                end,
            }
        }
    },

    confirm_opts = {
        behavior = ConfirmBehavior.Replace,
        select = false,
    },
    experimental = {
        ghost_text = true,
        native_menu = false,
    },
    mapping = cmp_mapping.preset.insert({
        ["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
        ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item { behavior = SelectBehavior.Select }, { "i" }),
        ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item { behavior = SelectBehavior.Select }, { "i" }),
        ["<C-d>"] = cmp_mapping.scroll_docs(-4),
        ["<C-f>"] = cmp_mapping.scroll_docs(4),
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
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif jumpable(1) then
                luasnip.jump(1)
            elseif has_words_before() then
                -- cmp.complete()
                fallback()
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
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'nvim_lsp_document_symbol' },
            { name = 'path' },
            { name = 'treesitter' },
            { name = 'luasnip' }, -- For luasnip users.
            {
                name = 'buffer',
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end
                }
            },
        },
        {
            -- { name = 'buffer' },
        }
    )
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
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]
--

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
