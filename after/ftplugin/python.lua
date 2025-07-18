local max_filesize = vim.g.max_filesize
local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(0))
if (ok and stats and stats.size > max_filesize) or vim.g.vscode then
    return
end

local default_options = {
    foldenable = true,
    -- foldmethod = "manual",
    foldlevel = 99,
    foldlevelstart = 99,
    foldnestmax = 9,
    foldminlines = 3,
}

for k, v in pairs(default_options) do
    vim.opt[k] = v
end

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
})
-- setup_lsp("ruff", {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { "ruff", "server", "--preview" },
-- })
setup_lsp("pyrefly", {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- INFO : text, markdown, org, norg
-- setup_lsp("ltex", {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     filetypes = { "text", "markdown", "org", "norg" },
-- })
setup_lsp("harper_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = vim.list_extend(
        {},
        { "text", "norg", "gitcommit" }
        -- lspconfig["harper_ls"].config_def.default_config.filetypes
    ),
})
