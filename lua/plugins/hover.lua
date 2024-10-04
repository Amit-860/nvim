return {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    keys = function()
        local hover = require("hover")
        return {
            -- Setup keymaps
            vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" }),
            -- vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" }),
            vim.keymap.set("n", "<tab>", function()
                hover.hover_switch("next")
            end, { desc = "hover.nvim (next source)" }),
            vim.keymap.set("n", "S<tab>", function()
                hover.hover_switch("previous")
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
                require("hover.providers.gh")
                require("hover.providers.gh_user")
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
            preview_window = true,
            title = true,
            mouse_providers = {
                "LSP",
            },
            mouse_delay = 2000,
        }

        local enable = {}
        local enable_lsp_rd_flag = function(bufnr)
            for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                local capable = client.server_capabilities or {}
                if capable.referencesProvider and capable.definitionProvider then
                    enable[bufnr] = true
                    return
                end
            end
            enable[bufnr] = false
        end

        hover.register({
            name = "D-R",
            priority = 500,
            --- @param bufnr integer
            enabled = function(bufnr)
                if enable[bufnr] ~= nil then
                    return enable[bufnr]
                end
                enable_lsp_rd_flag(bufnr)
                return enable[bufnr]
            end,
            --- @param opts Hover.Options
            --- @param done fun(result: any)
            execute = function(opts, done)
                local params = vim.lsp.util.make_position_params(0)
                params.context = { includeDeclaration = false }
                vim.lsp.buf_request(0, "textDocument/definition", params, function(d_err, defs)
                    vim.lsp.buf_request(0, "textDocument/references", params, function(r_err, refs)
                        if not d_err and not r_err and defs ~= nil and refs ~= nil then
                            done({
                                lines = { ("Definitions : **%s** | References : **%s**"):format(#defs, #refs) },
                                filetype = "markdown",
                            })
                        end
                    end)
                end)
            end,
        })

        hover.setup(hover_opts)
    end,
}
