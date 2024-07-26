local lsp_utils = require("lsp_utils")

vim.diagnostic.config(lsp_utils.default_diagnostic_config)

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Disabled as using Noice for this
local hover_opts = {
    -- Use a sharp border with `FloatBorder` highlights
    border = "none",
    -- add the title in hover float window
    -- title = "hover"
    relative = 'win',
    max_height = math.floor(vim.o.lines * 0.6),
    max_width = math.floor(vim.o.columns * 0.5),
}
if not vim.g.neovide then
    -- [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ].
    hover_opts.border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }
end
local status, _ = pcall(require, "noice")
if not status then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_opts)
end

vim.keymap.set({ "n" }, "<F3>k", lsp_utils.open_diagnostics_float,
    { desc = "Open diagnostics float", noremap = true, })

-- NOTE : lsp autocmds
local lsp_attach_aug = vim.api.nvim_create_augroup("lsp_attach_aug", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        lsp_utils.on_attach(client, 0)
    end,
    group = lsp_attach_aug,
})
