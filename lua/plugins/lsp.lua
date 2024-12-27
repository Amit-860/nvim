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
    {
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
                },
                automatic_installation = false,
            })
        end,
    },
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
        "neovim/nvim-lspconfig",
        event = { "BufNewFile", "BufReadPre" },
        cond = not vim.g.vscode,
        dependencies = {
            "williamboman/mason.nvim",
            -- "nvim-java/nvim-java",
        },
        config = function()
            require("lsp_opts")
            local lsp_utils = require("lsp_utils")
            local on_attach = lsp_utils.on_attach

            -- Set up lspconfig.
            local lspconfig = require("lspconfig")

            local capabilities = lsp_utils.lsp_capabilities
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

            -- Comment below line to disable lsp support for nvim files

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

            -- -- INFO: Java

            -- local java_ok, java = pcall(require, "java")
            -- if java_ok then
            --     java.setup({
            --         -- jdtls = { version = "latest" },
            --         -- lombok = { version = "nightly" },
            --         -- -- load java test plugins
            --         -- java_test = { enable = true, version = "latest" },
            --         -- -- load java debugger plugins
            --         -- java_debug_adapter = { enable = true, version = "0.*" },
            --         -- spring_boot_tools = { enable = true, version = "1.*" },
            --         jdk = { auto_install = false },
            --         notifications = { dap = true },
            --     })
            -- end
            -- setup_lsp("jdtls", {
            --     on_attach = on_attach,
            --     capabilities = capabilities,
            --     autostart = false,
            --     handlers = { ["$/progress"] = function(_, result, ctx) end },
            --     settings = {
            --         java = {
            --             implementationsCodeLens = { enabled = false },
            --             referencesCodeLens = { enabled = false },
            --             references = { includeDecompiledSources = true },
            --             signatureHelp = { enabled = true },
            --             inlayHints = { parameterNames = { enabled = "all" } },
            --             saveActions = { organizeImports = false },
            --             format = {
            --                 enabled = true,
            --                 comments = { enabled = true },
            --                 insertSpaces = true,
            --                 onType = { enabled = true },
            --                 settings = {
            --                     profile = "GoogleStyle",
            --                     url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
            --                 },
            --                 tabSize = 4,
            --             },
            --             completion = {
            --                 maxResults = 20,
            --                 importOrder = {
            --                     "java",
            --                     "javax",
            --                     "com",
            --                     "org",
            --                 },
            --             },
            --             sources = {
            --                 organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
            --             },
            --             codeGeneration = {
            --                 toString = {
            --                     template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            --                 },
            --                 useBlocks = true,
            --             },
            --         },
            --     },
            -- })

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
