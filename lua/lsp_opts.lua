local M = {}

M.lsp_feature_opts = {
    inlay_hints = {
        enabled = false,
        exclude = {},
    },
    code_lens = {
        enabled = false,
        exclude = {},
    },
}

M.diagnostic_signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
M.virtual_text_signs = {
    source = "if_many",
    -- prefix = " ",
    -- prefix = " ",
    -- prefix = "⏺ ",
    -- prefix = "󱡞 ",
    -- prefix = " ",
    prefix = "",
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

return M
