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

            local capabilities = lsp_utils.lsp_capabilities()
            local function setup_lsp(server, opts)
                if type(server) ~= "string" or server == "" then
                    print("Error: Invalid LSP server name provided:", server)
                    return
                end
                if server ~= nil then
                    local default_lsp_config = vim.lsp.config[server]
                    vim.lsp.config[server] = vim.tbl_deep_extend("force", {}, default_lsp_config, opts)
                    vim.lsp.enable(server)
                end
            end

            -- INFO: ================== setting up vim lsp settings ================
            lsp_utils.setup()
            lsp_utils.global_lsp_setup()

            -- INFO: ===================== setting up servers ======================

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "text", "markdown", "norg", "gitcommit" },
                callback = function()
                    -- INFO : text, markdown, org, norg
                    -- setup_lsp("ltex", {
                    --     on_attach = on_attach,
                    --     capabilities = capabilities,
                    --     filetypes = { "text", "markdown", "norg" },
                    -- })
                    setup_lsp("harper_ls", {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        filetypes = vim.list_extend(
                            {},
                            { "text", "markdown", "norg", "gitcommit" }
                            -- lspconfig["harper_ls"].config_def.default_config.filetypes
                        ),
                    })
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "html", "css", "typescript", "javascript", "typescriptreact", "javascriptreact" },
                callback = function()
                    -- INFO: html, css
                    setup_lsp("html", {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                    setup_lsp("cssls", {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                    setup_lsp("cssmodules_ls", {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        filetypes = { "css", "scss", "html", "typescriptreact", "javascriptreact" },
                    })
                    setup_lsp("emmet_language_server", {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
}
