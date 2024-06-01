-- If you want insert `(` after select function or method item
local autopair = require('nvim-autopairs')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_status, cmp = pcall(require, 'cmp')

local autopair_opts = {
    enable_abbr = true,
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        before_key = 'h',
        after_key = 'l',
        cursor_pos_before = true,
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        manual_position = true,
        highlight = 'Search',
        highlight_grey = 'Comment'
    }
}

autopair.setup(autopair_opts)

if cmp_status then
    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )

    local handlers = require('nvim-autopairs.completion.handlers')

    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done({
            filetypes = {
                -- "*" is a alias to all filetypes
                ["*"] = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method,
                        },
                        handler = handlers["*"]
                    }
                },
                lua = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method
                        },
                        ---@param char string
                        ---@param item table item completion
                        ---@param bufnr number buffer number
                        ---@param rules table
                        ---@param commit_character table<string>
                        handler = function(char, item, bufnr, rules, commit_character)
                            -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
                        end
                    }
                },
                -- Disable for tex
                tex = false
            }
        })
    )
end
