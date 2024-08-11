return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        cond = false,
        event = { "VeryLazy" },
        config = function()
            -- mason configs
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "basedpyright",
                    "ruff",
                    "jsonls",
                    "ltex",
                    "denols",
                    "html",
                    "cssls",
                    "cssmodules_ls",
                    "emmet_language_server",
                },
                automatic_installation = false,
            })
        end,
    },
    {
        "antosha417/nvim-lsp-file-operations",
        event = { "LspAttach" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("lsp_opts")
            local on_attach = require("lsp_utils").on_attach

            -- Set up lspconfig.
            local lspconfig = require("lspconfig")

            -- setup lsp servers
            -- add any global capabilities here
            local capabilities_opts = {
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
                -- textDocument = {
                --     completion = {
                --         completionItem = {
                --             snippetSupport = true
                --         },
                --     }
                -- },
                -- references = {
                --     dynamicRegistration = true
                -- },
                -- semanticTokens = {
                --     dynamicRegistration = true,
                -- },
                -- signatureHelp = {
                --     dynamicRegistration = true,
                -- },
            }

            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lsp_file_capabilities = require("lsp-file-operations").default_capabilities()
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_capabilities or {},
                lsp_file_capabilities or {},
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

            -- INFO : lua
            local lua_ls_settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    codeLens = { enable = false },
                    completion = { callSnippet = "Replace" },
                    doc = { privateName = { "^_" } },
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = true,
                        semicolon = "Disable",
                        arrayIndex = "Disable",
                    },
                },
            }
            setup_lsp("lua_ls", {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = lua_ls_settings,
                autostart = false,
            })

            -- INFO : python
            local basedpyright_settings = {
                basedpyright = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                        typeCheckingMode = "basic", -- ["off", "basic", "standard", "strict", "all"]
                    },
                },
            }
            setup_lsp("basedpyright", {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = basedpyright_settings,
                autostart = false,
            })
            setup_lsp("ruff", {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { "ruff", "server", "--preview" },
                autostart = false,
            })

            -- INFO : Json
            setup_lsp("jsonls", {
                on_attach = on_attach,
                capabilities = capabilities,
                autostart = false,
            })

            -- INFO : text, markdown, org, norg
            setup_lsp("ltex", {
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { "tex", "markdown", "org", "norg" },
                autostart = false,
            })

            -- INFO : javascript, html, css
            vim.g.markdown_fenced_languages = { "ts=typescript" }
            setup_lsp("denols", {
                on_attach = on_attach,
                capabilities = capabilities,
                autostart = false,
                filetypes = { "javascript", "typescript", "html", "css" },
            })
            setup_lsp("html", {
                on_attach = on_attach,
                capabilities = capabilities,
                autostart = false,
            })
            setup_lsp("cssls", {
                on_attach = on_attach,
                capabilities = capabilities,
                autostart = false,
            })
            setup_lsp("cssmodules_ls", {
                on_attach = on_attach,
                capabilities = capabilities,
                autostart = false,
            })
            setup_lsp("emmet_language_server", {
                on_attach = on_attach,
                capabilities = capabilities,
                autostart = false,
            })

            vim.api.nvim_create_autocmd({ "BufReadPre" }, {
                group = vim.api.nvim_create_augroup("Toggle_LSP_ag", { clear = true }),
                pattern = "*",
                callback = function(event)
                    local max_filesize = 1020 * 1024 * 2 -- 2MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(event.buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.cmd("LspStop")
                    else
                        vim.cmd("LspStart")
                    end
                end,
            })
        end,
    },
}
