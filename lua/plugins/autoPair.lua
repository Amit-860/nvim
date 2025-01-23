return {
    -- {
    --     "windwp/nvim-autopairs",
    --     event = "InsertEnter",
    --     opts = {
    --         enable_abbr = true,
    --         fast_wrap = {
    --             map = "<M-e>",
    --             chars = { "{", "[", "(", '"', "'" },
    --             pattern = [=[[%'%"%>%]%)%}%,]]=],
    --             end_key = "$",
    --             before_key = "h",
    --             after_key = "l",
    --             cursor_pos_before = true,
    --             keys = "qwertyuiopzxcvbnmasdfghjkl",
    --             manual_position = true,
    --             highlight = "Search",
    --             highlight_grey = "Comment",
    --         },
    --     },
    --     config = function(_, opts)
    --         local autopair = require("nvim-autopairs")
    --         local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    --         local cmp_status, cmp = pcall(require, "cmp")
    --
    --         autopair.setup(opts)
    --
    --         if cmp_status then
    --             cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    --
    --             local handlers = require("nvim-autopairs.completion.handlers")
    --
    --             cmp.event:on(
    --                 "confirm_done",
    --                 cmp_autopairs.on_confirm_done({
    --                     filetypes = {
    --                         -- "*" is a alias to all filetypes
    --                         ["*"] = {
    --                             ["("] = {
    --                                 kind = {
    --                                     cmp.lsp.CompletionItemKind.Function,
    --                                     cmp.lsp.CompletionItemKind.Method,
    --                                 },
    --                                 handler = handlers["*"],
    --                             },
    --                         },
    --                         lua = {
    --                             ["("] = {
    --                                 kind = {
    --                                     cmp.lsp.CompletionItemKind.Function,
    --                                     cmp.lsp.CompletionItemKind.Method,
    --                                 },
    --                                 ---@param char string
    --                                 ---@param item table item completion
    --                                 ---@param bufnr number buffer number
    --                                 ---@param rules table
    --                                 ---@param commit_character table<string>
    --                                 handler = function(char, item, bufnr, rules, commit_character)
    --                                     -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
    --                                 end,
    --                             },
    --                         },
    --                         -- Disable for tex
    --                         tex = false,
    --                     },
    --                 })
    --             )
    --         end
    --     end,
    -- },
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        cond = not vim.g.vscode,
        -- branch = "v0.6", --recommended as each new version will have breaking changes
        opts = {
            tabout = {
                enable = true,
                map = "<A-l>",
                cmap = "<A-l>",
                hopout = true,
            },
            cr = { enable = true },
            bs = { enable = true },
            close = { enable = true },
            space2 = { enable = true },
            fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
                enable = true,
                enable_normal = true,
                enable_reverse = true,
                hopout = false,
                map = "<A-]>", --string or table
                rmap = "<A-[>", --string or table
                cmap = "<A-]>", --string or table
                rcmap = "<A-[>", --string or table
                multiline = true,
                nocursormove = true,
                do_nothing_if_fail = true,
                no_filter_nodes = { "string", "raw_string", "string_literals", "character_literal" },
                faster = true,
                conf = {},
                multi = false,
            },
            extensions = {
                cmdtype = { skip = { "/", "?", "@", "-" }, p = 100 },
                filetype = { p = 90, nft = { "TelescopePrompt" }, tree = true },
                escape = { filter = true, p = 80 },
                utf8 = { p = 70 },
                tsnode = {
                    p = 60,
                    separate = {
                        "comment",
                        "string",
                        "char",
                        "character",
                        "raw_string", --fish/bash/sh
                        "char_literal",
                        "string_literal", --c/cpp
                        "string_value", --css
                        "str_lit",
                        "char_lit", --clojure/commonlisp
                        "interpreted_string_literal",
                        "raw_string_literal",
                        "rune_literal", --go
                        "quoted_attribute_value", --html
                        "template_string", --javascript
                        "LINESTRING",
                        "STRINGLITERALSINGLE",
                        "CHAR_LITERAL", --zig
                        "string_literals",
                        "character_literal",
                        "line_comment",
                        "block_comment",
                        "nesting_block_comment", --d #62
                    },
                },
                cond = { p = 40, filter = true },
                alpha = { p = 30, filter = false, all = false },
                suround = { p = 20 },
                fly = {
                    other_char = { " " },
                    nofilter = false,
                    p = 10,
                    undomapconf = {},
                    undomap = nil,
                    undocmap = nil,
                    only_jump_end_pair = false,
                },
            },
            internal_pairs = {
                { "[", "]", fly = true, dosuround = true, newline = true, space = true },
                { "(", ")", fly = true, dosuround = true, newline = true, space = true },
                { "{", "}", fly = true, dosuround = true, newline = true, space = true },
                { '"', '"', suround = true, multiline = false },
                {
                    "'",
                    "'",
                    suround = true,
                    cond = function(fn)
                        return not fn.in_lisp() or fn.in_string()
                    end,
                    alpha = true,
                    nft = { "tex" },
                    multiline = false,
                },
                {
                    "`",
                    "`",
                    cond = function(fn)
                        return not fn.in_lisp() or fn.in_string()
                    end,
                    nft = { "tex" },
                    multiline = false,
                },
                { "``", "''", ft = { "tex" } },
                { "```", "```", newline = true, ft = { "markdown" } },
                { "<!--", "-->", ft = { "markdown", "html" }, space = true },
                { '"""', '"""', newline = true, ft = { "python" } },
                { "'''", "'''", newline = true, ft = { "python" } },
            },
        },
    },
}
