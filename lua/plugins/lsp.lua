return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        cond = not vim.g.vscode,
        opts = {
            registries = {
                "github:nvim-java/mason-registry",
                "github:mason-org/mason-registry",
            },
        },
    },
    --[[ {
        "williamboman/mason-lspconfig.nvim",
        cond = not vim.g.vscode,
        event = { "BufNewFile", "BufReadPost" },
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
                    "jdtls",
                },
                automatic_installation = false,
            })
        end,
    }, ]]
    {
        "antosha417/nvim-lsp-file-operations",
        event = { "LspAttach" },
        cond = not vim.g.vscode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        ft = { "javascriptreact", "typescriptreact" },
        cond = not vim.g.vscode,
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = function()
            local lsp_utils = require("lsp_utils")
            return {
                on_attach = lsp_utils.on_attach,
                capabilities = lsp_utils.lsp_capabilities(),
                settings = {
                    format = { enable = false },
                    tsserver_format_options = {
                        semicolons = "insert",
                    },
                    separate_diagnostic_server = true,
                    expose_as_code_action = "all",
                    -- tsserver_plugins = {},
                    tsserver_max_memory = "auto",
                    complete_function_calls = true,
                    include_completions_with_insert_text = true,
                    tsserver_file_preferences = {
                        quotePreference = "single", -- auto | double | single
                        includeInlayParameterNameHints = "all", -- "none" | "literals" | "all";
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                        includeCompletionsForModuleExports = true,
                        autoImportFileExcludePatterns = { "node_modules/*", ".git/*" },
                    },
                },
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        cond = not vim.g.vscode,
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("lsp_opts")
            local lsp_utils = require("lsp_utils")
            local on_attach = lsp_utils.on_attach

            -- Set up lspconfig.
            local lspconfig = require("lspconfig")

            local capabilities = lsp_utils.lsp_capabilities()
            local function setup_lsp(server, opts)
                -- lspconfig[server].setup(opts)
                local conf = lspconfig[server]
                conf.setup(opts)
                local try_add = conf.manager.try_add
                conf.manager.try_add = function(bufnr)
                    return try_add(bufnr)
                end
            end

            local lsp_opts = {
                inlay_hints = {
                    enabled = true,
                    exclude = {},
                },
                code_lens = {
                    enabled = false,
                    exclude = {},
                },
            }

            lsp_utils.setup()
            lsp_utils.global_lsp_setup(lsp_opts)

            -- INFO: ===================== setting up servers ======================
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

            -- INFO : GO
            setup_lsp("gopls", {
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
            -- setup_lsp("harper_ls", {
            --     on_attach = on_attach,
            --     capabilities = capabilities,
            --     filetypes = vim.list_extend(
            --         { "text", "norg", "gitcommit" },
            --         lspconfig["harper_ls"].config_def.default_config.filetypes
            --     ),
            --     autostart = false,
            -- })

            -- INFO : JavaScript, html, css
            vim.g.markdown_fenced_languages = { "ts=typescript" }
            setup_lsp("denols", {
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { "javascript", "typescript", "html", "css" },
                autostart = false,
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
                filetypes = { "css", "scss", "html", "typescriptreact", "javascriptreact" },
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
