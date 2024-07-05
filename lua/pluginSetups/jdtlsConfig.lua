local jdtls = require('jdtls')
local mason_registry = require("mason-registry")
local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
-- local lombok_path = vim.fn.stdpath('data') .. "mason/packages/lombok-nightly/lombok.jar"
local lombok_path = jdtls_path .. "/lombok.jar"

-- Setup Workspace
local home = vim.fn.expand("$HOME")
local workspace_path = home .. "/jdtls_workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name
local os_config = 'win'
local bundles = {
    vim.fn.glob(mason_registry.get_package('java-debug-adapter'):get_install_path() ..
        "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
}

local config = {
    root_dir = jdtls.setup.find_root({ ".metadata", ".git", "pom.xml", 'build.gradle', 'mvnw' }),
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        -- '--jvm-arg=-javaagent:' .. lombok_path .. ' --jvm-arg=-Xbootclasspath/a:' .. lombok_path, -- uncomment for lombok support
        "-jar",
        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_path .. "/config_" .. os_config,
        "-data",
        workspace_dir
    },
    flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
    },
    on_init = function(client)
        if client.config.settings then
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
    end,
    init_options = {
        bundles = bundles,
    },
    on_attach = function(client, bufnr)
        if client.name == "jdtls" then
            jdtls = require("jdtls")
            jdtls.setup_dap({ hotcodereplace = "auto" })
            jdtls.setup.add_commands()
            -- Auto-detect main and setup dap config
            -- require("jdtls.dap").setup_dap_main_class_configs({
            -- config_overrides = { vmArgs = "-Dspring.profiles.active=local", },
            -- })
            require("jdtls.dap").setup_dap_main_class_configs({})
            --
            -- Add specific keys for jdtls
            --
        end
    end,

    -- These depend on nvim-dap, but can additionally be disabled by setting false here.
    dap = { hotcodereplace = "auto", config_overrides = {} },
    dap_main = {},
    test = true,
    settings = {
        java = {
            eclipse = { downloadSources = true, },
            maven = { downloadSources = true, },
            implementationsCodeLens = { enabled = true, },
            referencesCodeLens = { enabled = true, },
            references = { includeDecompiledSources = true, },
            signatureHelp = { enabled = true },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            saveActions = { organizeImports = true },
            completion = {
                maxResults = 20,
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                importOrder = {
                    "java", "javax", "com", "org"
                },
            },
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
            },
        },
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities()
}


local jdtls_aug = vim.api.nvim_create_augroup("jdtls_aug", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function()
        jdtls.start_or_attach(config)
        local _, _ = pcall(vim.lsp.codelens.refresh)
    end,
    pattern = "java",
    group = jdtls_aug,
})
