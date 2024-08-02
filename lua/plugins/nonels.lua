return {
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPost", "BufNewFile" },
        -- keys = function()
        --     return {
        --         vim.keymap.set({ "n" }, "<leader>lf", function()
        --             local flag = nil
        --             vim.lsp.buf.format({
        --                 buf = 0,
        --                 filter = function(client)
        --                     flag = client.name == "null-ls"
        --                     return flag
        --                 end,
        --             })
        --             if not flag then
        --                 vim.lsp.buf.format()
        --             end
        --         end, { desc = "Format", noremap = true }),
        --     }
        -- end,
        config = function()
            local null_ls = require("null-ls")
            local code_actions = null_ls.builtins.code_actions
            local diagnostics = null_ls.builtins.diagnostics
            local formatting = null_ls.builtins.formatting
            local hover = null_ls.builtins.hover
            local completion = null_ls.builtins.completion

            local sources = {
                -- codeaction sources
                code_actions.ts_node_action,
                code_actions.gitsigns,

                -- lintter sources
                diagnostics.pylint.with({
                    diagnostics_postprocess = function(diagnostic)
                        diagnostic.code = diagnostic.message_id
                    end,
                }),
                diagnostics.sqlfluff.with({
                    extra_args = { "--dialect", "postgres" }, -- change to your dialect
                }),
                diagnostics.todo_comments,
                diagnostics.write_good.with({
                    extra_filetypes = { "text", "norg" },
                }),
                -- formatter sources
                -- formatting.prettierd.with({
                --     filetype = {
                --         "vue",
                --         "css",
                --         "scss",
                --         "less",
                --         "html",
                --         "yaml",
                --         "markdown",
                --         "markdown.mdx",
                --         "graphql",
                --         "handlebars",
                --         "svelte",
                --         "astro",
                --         "htmlangular",
                --     },
                -- }),
                -- formatting.biome,
                -- formatting.stylua.with({
                --     extra_args = { "--indent-type", "Spaces", "--line-endings", "Windows" },
                -- }),
                -- formatting.black,
                -- formatting.isort,
                -- formatting.google_java_format,

                -- hover sources
                hover.dictionary,
            }

            --INFO : add extra_filetypes
            --[[ formatting.prettier.with({ extra_filetypes = { "toml" }}) ]]

            -- local none_ls_augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
            null_ls.setup({
                sources = sources,
                --     on_attach = function(client, bufnr)
                --         if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                --             return
                --         end
                --         if client.supports_method("textDocument/formatting") then
                --             -- vim.api.nvim_clear_autocmds({ group = none_ls_augroup, buffer = bufnr })
                --             vim.api.nvim_create_autocmd("BufWritePre", {
                --                 group = none_ls_augroup,
                --                 buffer = bufnr,
                --                 callback = function()
                --                     local flag = nil
                --                     vim.lsp.buf.format({
                --                         buf = bufnr,
                --                         filter = function(agent)
                --                             flag = agent.name == "null-ls"
                --                             return flag
                --                         end,
                --                     })
                --                     if not flag then
                --                         vim.lsp.buf.format()
                --                     end
                --                 end,
                --             })
                --         end
                --     end,
            })
        end,
    },
}
