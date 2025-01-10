local M = {}

M.diagnostic_signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
M.virtual_text_signs = {
    source = "if_many",
    -- prefix = " ",
    prefix = " ",
    -- prefix = "⏺ ",
}
M.default_diagnostic_config = {
    signs = {
        active = true,
        text = {
            [vim.diagnostic.severity.ERROR] = M.diagnostic_signs.Error,
            [vim.diagnostic.severity.WARN] = M.diagnostic_signs.Warn,
            [vim.diagnostic.severity.HINT] = M.diagnostic_signs.Hint,
            [vim.diagnostic.severity.INFO] = M.diagnostic_signs.Info,
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSign" .. "Error",
            [vim.diagnostic.severity.WARN] = "DiagnosticSign" .. "Warn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSign" .. "Hint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSign" .. "Info",
        },
    },
    virtual_text = M.virtual_text_signs,
    virtual_lines = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "single",
        source = "always",
        header = "",
        prefix = "",
    },
}

M.default_capabilities_opts = {
    workspace = {
        fileOperations = {
            didRename = true,
            willRename = true,
        },
        didChangeWorkspaceFolders = {
            dynamicRegistration = true,
        },
        didChangeConfiguration = {
            dynamicRegistration = true,
        },
    },
    textDocument = {
        semanticTokens = {
            dynamicRegistration = true,
        },
        callHierarchy = {
            dynamicRegistration = true,
        },
        synchronization = {
            didChange = true,
            willSave = true,
            dynamicRegistration = true,
            willSaveWaitUntil = true,
            didSave = true,
        },
    },
}

M.open_diagnostics_float = function()
    vim.diagnostic.open_float({
        scope = "cursor",
        focusable = false,
        border = "single",
        close_events = {
            "CursorMoved",
            "CursorMovedI",
            "BufHidden",
            "InsertCharPre",
            "WinLeave",
            "InsertEnter",
            "InsertLeave",
        },
    })
end

vim.diagnostic.config(M.default_diagnostic_config)

-- Disabled as using Noice for this
local hover_opts = {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
    -- add the title in hover float window
    -- title = "hover",
    relative = "win",
    max_height = math.floor(vim.o.lines * 0.6),
    max_width = math.floor(vim.o.columns * 0.5),
}
if not vim.g.neovide then
    -- [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ].
    hover_opts.border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" }
end
local status_noice, _ = pcall(require, "noice")
local status_hover, _ = pcall(require, "hover")
if not (status_noice or status_hover) then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_opts)
end

local signature_help_opts = {
    -- title = "signature help",
    scope = "cursor",
    focusable = false,
    border = "single",
    close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
        "InsertEnter",
        "InsertLeave",
    },
    padding = { 0, 0 },
}
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, signature_help_opts)

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

return M
