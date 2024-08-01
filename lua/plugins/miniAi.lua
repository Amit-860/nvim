return {
    "echasnovski/mini.ai",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
        local ai = require("mini.ai")
        return {
            -- Number of lines within which textobject is searched
            n_lines = 50,

            -- Table with textobject id as fields, textobject specification as values.
            -- Also use this to disable builtin textobjects. See |MiniAi.config|.

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                -- Main textobject prefixes
                around = 'a',
                inside = 'i',

                -- Next/last textobjects
                around_next = 'an',
                inside_next = 'in',
                around_last = 'aL',
                inside_last = 'iL',

                -- Move cursor to corresponding edge of `a` textobject
                goto_left = 'g[',
                goto_right = 'g]',
            },

            -- How to search for object (first inside current line, then inside
            -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
            -- 'cover_or_nearest', 'next', 'prev', 'nearest'.
            search_method = 'cover_or_next',

            -- Whether to disable showing non-error feedback
            silent = false,

            custom_textobjects = {
                o = ai.gen_spec.treesitter({
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }, {}),
                t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                D = { "%f[%d]%d+" }, -- digits
                e = {                -- Word with case
                    {
                        "%u[%l%d]+%f[^%l%d]",
                        "%f[%S][%l%d]+%f[^%l%d]",
                        "%f[%P][%l%d]+%f[^%l%d]",
                        "^[%l%d]+%f[^%l%d]",
                    },
                    "^().*()$",
                },
                G = function() -- Whole buffer, similar to `gg` and 'G' motion
                    local from = { line = 1, col = 1 }
                    local to = {
                        line = vim.fn.line("$"),
                        col = math.max(vim.fn.getline("$"):len(), 1),
                    }
                    return { from = from, to = to }
                end,
                u = ai.gen_spec.function_call(),                           -- u for "Usage"
                U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
            },
        }
    end,
    config = function(_, opts)
        local utils = require('utils')
        require("mini.ai").setup(opts)
        -- register all text objects with which-key
        utils.on_load("which-key.nvim", function()
            ---@type table<string, string|table>
            local i = {
                [" "] = "Whitespace",
                ['"'] = 'Balanced "',
                ["'"] = "Balanced '",
                ["`"] = "Balanced `",
                ["("] = "Balanced (",
                [")"] = "Balanced ) including white-space",
                [">"] = "Balanced > including white-space",
                ["<lt>"] = "Balanced <",
                ["]"] = "Balanced ] including white-space",
                ["["] = "Balanced [",
                ["}"] = "Balanced } including white-space",
                ["{"] = "Balanced {",
                ["?"] = "User Prompt",
                _ = "Underscore",
                a = "Argument",
                b = "Balanced ), ], }",
                c = "Class",
                D = "Digit(s)",
                e = "Word in CamelCase & snake_case",
                f = "Function",
                G = "Entire file",
                o = "Block, conditional, loop",
                q = "Quote `, \", '",
                t = "Tag",
                u = "Use/call function & method",
                U = "Use/call without dot in name",
            }
            local a = vim.deepcopy(i)
            for k, v in pairs(a) do
                a[k] = v:gsub(" including.*", "")
            end

            local keys = {
                mode = { 'o', 'x' },
                { 'i', { group = "inside" } },
                { 'a', { group = "around" } },
            }

            for key, name in pairs(i) do
                table.insert(keys, { 'i' .. key, desc = name })
            end
            for key, name in pairs(a) do
                table.insert(keys, { 'a' .. key, desc = name })
            end

            -- table.insert(keys, { 'il', { group = "Inside last textobject" } })
            -- table.insert(keys, { 'in', { group = "Inside next textobject" } })
            for key, name in pairs({ n = "next", l = "last" }) do
                for key_i, name_i in pairs(i) do
                    if key == 'n' then
                        table.insert(keys, { 'i' .. key .. key_i, desc = "Inside next " .. name_i })
                    else
                        table.insert(keys, { 'i' .. key .. key_i, desc = "Inside last " .. name_i })
                    end
                end
            end

            -- table.insert(keys, { 'al', { group = "Around last textobject" } })
            -- table.insert(keys, { 'an', { group = "Around next textobject" } })
            for key, name in pairs({ n = "next", l = "last" }) do
                for key_a, name_a in pairs(i) do
                    if key == 'n' then
                        table.insert(keys, { 'a' .. key .. key_a, desc = "Around next " .. name_a })
                    else
                        table.insert(keys, { 'a' .. key .. key_a, desc = "Around last " .. name_a })
                    end
                end
            end

            require("which-key").add(keys)
        end)
    end,
}
