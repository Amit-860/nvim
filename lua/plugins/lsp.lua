return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        dependencies = {
            {
                "williamboman/mason.nvim",
                cmd = "Mason"
            },
            {
                "williamboman/mason-lspconfig.nvim",
                config = function() end
            },
        },
        config = function()
            local on_attach = require('lsp_utils').on_attach
            -- mason configs
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "basedpyright", "ruff", "jsonls", "ltex", "denols", "html", "cssls", "cssmodules_ls", "emmet_language_server" },
                automatic_installation = false,
            })

            -- Set up lspconfig.
            local lspconfig = require('lspconfig')

            -- setup lsp servers
            -- add any global capabilities here
            local capabilities_opts = {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            }
            local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_capabilities or {},
                capabilities_opts or {}
            )

            local function setup_lsp(server, opts)
                -- lspconfig[server].setup(opts)
                local conf = lspconfig[server]
                conf.setup(opts)
                local try_add = conf.manager.try_add
                conf.manager.try_add = function(bufnr)
                    return try_add(bufnr)
                end
            end

            -- NOTE: ===================== setting up servers ======================

            -- comment below line to disable lsp support for nvim files
            -- NOTE : neodev for nvim apis
            -- require("neodev").setup({})


            -- NOTE : lua
            local lua_ls_settings = {
                Lua = {
                    workspace = { checkThirdParty = false, },
                    codeLens = { enable = false, },
                    completion = { callSnippet = "Replace", },
                    doc = { privateName = { "^_" }, },
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = true,
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                    }
                }
            }
            setup_lsp("lua_ls", { on_attach = on_attach, capabilities = capabilities, settings = lua_ls_settings, })

            -- NOTE : python
            local basedpyright_settings = {
                basedpyright = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = 'basic' -- ["off", "basic", "standard", "strict", "all"]
                    }
                }
            }
            setup_lsp("basedpyright",
                { on_attach = on_attach, capabilities = capabilities, settings = basedpyright_settings })
            setup_lsp("ruff", { on_attach = on_attach, capabilities = capabilities, })

            -- NOTE : Json
            setup_lsp("jsonls", { on_attach = on_attach, capabilities = capabilities, })

            -- NOTE : text
            -- setup_lsp("ltex",
            --     { on_attach = on_attach, capabilities = capabilities, filetypes = { 'gitcommit', 'markdown', 'org', 'norg', 'xhtml', } }
            -- )

            -- NOTE : javascript, html, css
            vim.g.markdown_fenced_languages = { "ts=typescript" }
            setup_lsp("denols", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("html", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("cssls", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("cssmodules_ls", { on_attach = on_attach, capabilities = capabilities, })
            setup_lsp("emmet_language_server", { on_attach = on_attach, capabilities = capabilities, })
        end
    }
}
