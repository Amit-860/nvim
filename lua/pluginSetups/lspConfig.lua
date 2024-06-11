require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright" },
    automatic_installation = false,
})

-- Set up lspconfig.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local function setup_lsp(server, opts)
    local conf = lspconfig[server]
    conf.setup(opts)
    local try_add = conf.manager.try_add
    conf.manager.try_add = function(bufnr)
        if not vim.b.large_buf then
            return try_add(bufnr)
        end
    end
end

local on_attach = function(client, bufnr)
    -- lsp keymap
    -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true, buffer=bufnr })
    vim.keymap.set({ "n", "i" }, "<c-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        { desc = "Signature Help", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
        { desc = "Code Action", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lr", "<cmd>Telescope lsp_references theme=get_ivy<CR>",
        { desc = "References", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>",
        { desc = "Rename Symbol", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>ld", "<cmd>Telescope lsp_definitions theme=get_ivy<CR>",
        { desc = "Definitions", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>li", "<cmd>Telescope lsp_implementations theme=get_ivy<CR>",
        { desc = "Implementations", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>ls", "<cmd>Telescope lsp_document_symbols theme=get_ivy<CR>",
        { desc = "Document Symbols", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lD", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<CR>",
        { desc = "Diagnostics", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lf", function() vim.lsp.buf.format() end,
        { desc = "Format", noremap = true, buffer = bufnr })

    -- toggle inlay_hint
    vim.keymap.set({ "n" }, "<leader>lH",
        function()
            local hint_flag = not vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(hint_flag)
        end,
        { desc = "Hints", noremap = true, buffer = bufnr })

    -- lsp lines
    local lsp_lines_enable = false
    vim.diagnostic.config({ virtual_lines = lsp_lines_enable })
    vim.keymap.set("n", "<leader>lh",
        function()
            vim.diagnostic.config({
                virtual_text = lsp_lines_enable,
                signs = true,
                underline = true,
                virtual_lines = not lsp_lines_enable
            })
            lsp_lines_enable = not lsp_lines_enable
        end,
        { desc = "Toggle HlChunk", noremap = true }
    )

    -- toggle LSP
    local lsp_enable = true
    vim.keymap.set("n", "<leader>lT",
        function()
            if lsp_enable then
                vim.cmd("LspStop")
                lsp_enable = not lsp_enable
            else
                vim.cmd("LspStart")
                lsp_enable = not lsp_enable
            end
            local msg = "LSP Enable : " .. string.upper(tostring(lsp_enable))
            vim.api.nvim_notify(msg, 0, {})
        end,
        { desc = "Toggle LSP", noremap = true }
    )

    -- inlay hint
    -- if client.server_capabilities.inlayHintProvider then
    --     vim.lsp.inlay_hint.enable(true)
    -- end

    -- Code Runner
    vim.keymap.set("n", "<leader>r", "<nop>", { desc = "which_key_ignore", noremap = true })
    vim.keymap.set("n", "<leader>rf", "<cmd>RunFile<CR>", { noremap = true, silent = true, desc = "Run File", })
    vim.keymap.set("n", "<leader>rc", "<cmd>RunCode<CR>", { noremap = true, silent = true, desc = "Run Code", })
    vim.keymap.set("n", "<F4>", "<cmd>RunCode<CR>", { noremap = true, silent = true, desc = "Run Code", })
end


-- comment below line to disable lsp support for nvim files
-- require("neodev").setup({})

local lua_ls_settings = {
    Lua = {
        workspace = { checkThirdParty = false, },
        codeLens = { enable = true, },
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

setup_lsp("lua_ls", { on_attach = on_attach, capabilities = capabilities, settings = lua_ls_settings })
setup_lsp("pyright", { on_attach = on_attach, capabilities = capabilities, })
setup_lsp("jsonls", { on_attach = on_attach, capabilities = capabilities, })
