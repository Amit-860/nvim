return {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    keys = function()
        local hover = require("hover")
        return {
            -- Setup keymaps
            vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" }),
            -- vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" }),
            vim.keymap.set("n", "<tab>", function()
                hover.hover_switch(
                    "next"
                    -- { bufnr = 0, pos = { 1, 1 } }
                )
            end, { desc = "hover.nvim (next source)" }),
            vim.keymap.set("n", "S<tab>", function()
                hover.hover_switch(
                    "previous"
                    -- { bufnr = 0, pos = { 1, 1 } }
                )
            end, { desc = "hover.nvim (previous source)" }),

            -- Mouse support
            -- vim.o.mousemoveevent = true
            -- vim.keymap.set("n", "<MouseMove>", hover.hover_mouse, { desc = "hover.nvim (mouse)" })
        }
    end,
    config = function()
        local hover = require("hover")
        local hover_opts = {
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                -- require("hover.providers.gh")
                -- require("hover.providers.gh_user")
                require("hover.providers.dap")
                require("hover.providers.fold_preview")
                require("hover.providers.diagnostic")
                require("hover.providers.man")
                -- require("hover.providers.dictionary")
            end,
            preview_opts = {
                border = "single",
            },
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = false,
            title = true,
            mouse_providers = {},
            mouse_delay = 2000,
        }

        local valid_filetypes = function(bufnr)
            local invalid_ft = {
                "NvimTree",
                "TelescopePrompt",
                "snacks_dashboard",
            }
            local file_type = vim.bo[bufnr].filetype
            return not vim.tbl_contains(invalid_ft, file_type)
        end

        local enable = {}
        local enable_lsp_rd_flag = function(bufnr)
            for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                local capable = client.server_capabilities or {}
                if capable.referencesProvider and capable.definitionProvider then
                    enable[bufnr] = true and valid_filetypes(bufnr)
                    return
                end
            end
            enable[bufnr] = false
        end

        hover.register({
            name = "Refs",
            priority = 500,
            --- @param bufnr integer
            enabled = function(bufnr)
                if enable[bufnr] ~= nil then
                    return enable[bufnr]
                end
                enable_lsp_rd_flag(bufnr)
                return enable[bufnr]
            end,
            execute = function(opts, done)
                local params = vim.lsp.util.make_position_params(0)
                params.context = { includeDeclaration = false }
                local thisFileUri = string.sub(vim.uri_from_fname(vim.api.nvim_buf_get_name(0)), 12)
                local lRefs = 0
                local gRefs = 0
                vim.lsp.buf_request(0, "textDocument/references", params, function(error, refs)
                    if not error and refs then
                        local localRef = 0
                        for _, ref in pairs(refs) do
                            if thisFileUri == string.sub(ref.uri, 14) then
                                localRef = localRef + 1
                            end
                        end
                        lRefs = localRef
                        gRefs = #refs
                        done({
                            lines = {
                                ("File : **%s** | Workspace : **%s**"):format(lRefs, gRefs),
                            },
                            filetype = "markdown",
                        })
                        return
                    else
                        return
                    end
                end)
            end,
        })

        hover.register({
            name = "Defs",
            priority = 400,
            --- @param bufnr integer
            enabled = function(bufnr)
                if enable[bufnr] ~= nil then
                    return enable[bufnr]
                end
                enable_lsp_rd_flag(bufnr)
                return enable[bufnr]
            end,
            execute = function(opts, done)
                local params = vim.lsp.util.make_position_params(0)
                params.context = { includeDeclaration = false }
                local thisFileUri = vim.uri_from_fname(vim.api.nvim_buf_get_name(0))
                local lDefs = 0
                local gDefs = 0
                vim.lsp.buf_request(0, "textDocument/definition", params, function(error, defs)
                    if not error and defs then
                        local localDef = 0
                        for _, ref in pairs(defs) do
                            if thisFileUri == ref.uri then
                                localDef = localDef + 1
                            end
                        end
                        lDefs = localDef
                        gDefs = #defs
                        done({
                            lines = {
                                ("File : **%s** | Workspace : **%s**"):format(lDefs, gDefs),
                            },
                            filetype = "markdown",
                        })
                        return
                    else
                        return
                    end
                end)
            end,
        })

        hover.register({
            name = "Dict",
            priority = 300,
            --- @param bufnr integer
            enabled = function(bufnr)
                return vim.api.nvim_buf_is_loaded(bufnr) and valid_filetypes(bufnr)
            end,
            --- @param opts Hover.Options
            --- @param done fun(result: any)
            execute = function(opts, done)
                -- Use vim.fn.systemlist to execute the command and get the output as a list of lines
                local cword = vim.fn.expand("<cword>")
                -- local result = { "**" .. cword .. "**" }
                local output = vim.fn.systemlist({
                    "wn",
                    cword,
                    "-over",
                })
                -- vim.list_extend(result, output)
                done({
                    lines = output,
                    filetype = "markdown",
                })
            end,
        })

        hover.setup(hover_opts)
    end,
}
