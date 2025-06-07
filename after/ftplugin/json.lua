local default_options = {
    foldenable = true,
    -- foldmethod = "manual",
    foldmethod = "expr", -- folding, set to "expr" for treesitter based folding / "manual"
    foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
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

-- INFO : Json
setup_lsp("jsonls", {
    on_attach = on_attach,
    capabilities = capabilities,
})
