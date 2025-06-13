local max_filesize = vim.g.max_filesize
local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(0))
if (ok and stats and stats.size > max_filesize) or vim.g.vscode then
    return
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
})
