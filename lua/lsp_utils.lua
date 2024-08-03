local M = {}
local icons = require("icons")
local utils = require("utils")

M.default_diagnostic_config = {
    signs = {
        active = true,
        values = {
            { name = "DiagnosticSignError", text = icons.diagnostics.Error },
            { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
            { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
            { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
        },
    },
    virtual_text = {
        source = "if_many",
        -- prefix = ' ',
        prefix = " ",
        -- prefix = "⏺ "
    },
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

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}
---@param opts? lsp.Client.filter
function M.get_clients(opts)
    local ret = {} ---@type vim.lsp.Client[]
    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
            ---@param client vim.lsp.Client
            ret = vim.tbl_filter(function(client)
                return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
        end
    end
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.lsp_on_attach(on_attach, name)
    return vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (not name or client.name == name) then
                return on_attach(client, buffer)
            end
        end,
    })
end

-- NOTE: adding LspDynamicCapability
M.supports_method = {}

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function M.on_dynamic_capability(fn, opts)
    return vim.api.nvim_create_autocmd("User", {
        pattern = "LspDynamicCapability",
        group = opts and opts.group or nil,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local buffer = args.data.buffer ---@type number
            if client then
                return fn(client, buffer)
            end
        end,
    })
end

---@param client vim.lsp.Client
function M.check_methods(client, buffer)
    -- don't trigger on invalid buffers
    if not vim.api.nvim_buf_is_valid(buffer) then
        return
    end
    -- don't trigger on non-listed buffers
    if not vim.bo[buffer].buflisted then
        return
    end
    -- don't trigger on nofile buffers
    if vim.bo[buffer].buftype == "nofile" then
        return
    end
    for method, clients in pairs(M.supports_method) do
        clients[client] = clients[client] or {}
        if not clients[client][buffer] then
            if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
                clients[client][buffer] = true
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "LspSupportsMethod",
                    data = { client_id = client.id, buffer = buffer, method = method },
                })
            end
        end
    end
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
    M.supports_method[method] = M.supports_method[method] or setmetatable({}, { __mode = "k" })
    return vim.api.nvim_create_autocmd("User", {
        pattern = "LspSupportsMethod",
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local buffer = args.data.buffer ---@type number
            if client and method == args.data.method then
                return fn(client, buffer)
            end
        end,
    })
end

function M.setup()
    local register_capability = vim.lsp.handlers["client/registerCapability"]
    vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        ---@diagnostic disable-next-line: no-unknown
        local ret = register_capability(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            for buffer in pairs(client.attached_buffers) do
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "LspDynamicCapability",
                    data = { client_id = client.id, buffer = buffer },
                })
            end
        end
        return ret
    end
    M.lsp_on_attach(M.check_methods)
    M.on_dynamic_capability(M.check_methods)
end

-- -- NOTE: Utilize on_supports_method for using lsp capbilities
-- on_supports_method("workspace/didRenameFiles", function(_, buf)
--     vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved", }, {
--         group = vim.api.nvim_create_augroup("lsp_word_" .. buf, { clear = true }),
--         buffer = buf,
--         callback = function(ev)
--             print(vim.inspect(ev))
--         end,
--     })
-- end)

-- INFO: on_attach func =========================================================================
M.on_attach = function(client, bufnr)
    -- NOTE: inlay hint
    local inlay_hint_flag = true
    -- if client.server_capabilities.inlayHintProvider then
    if inlay_hint_flag and client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(false)
    end

    -- NOTE: code_lens
    local code_lens_flag = false
    -- if client.server_capabilities.codeLensProvider then
    if code_lens_flag and client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end

    ---INFO: reaname ----------------------------------------------------------------------------------
    ---@param from string
    ---@param to string
    ---@param rename? fun()
    local function on_rename(from, to, rename)
        local changes = {
            files = {
                {
                    oldUri = vim.uri_from_fname(from),
                    newUri = vim.uri_from_fname(to),
                },
            },
        }

        if client.supports_method("workspace/willRenameFiles") then
            local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end
        end

        if rename then
            rename()
        end
        if client.supports_method("workspace/didRenameFiles") then
            client.notify("workspace/didRenameFiles", changes)
        end
    end

    local _, nvim_tree_api = pcall(require, "nvim-tree.api")
    local Event = nvim_tree_api.events.Event
    nvim_tree_api.events.subscribe(Event.NodeRenamed, function(data)
        on_rename(data.old_name, data.new_name, function() end)
    end)

    -- NOTE: lsp keymap ---------------------------------------------------------------------------------
    -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true, buffer=bufnr })
    vim.keymap.set(
        { "n", "i" },
        "<M-i>",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        { desc = "Signature Help", noremap = true, buffer = bufnr }
    )
    -- vim.keymap.set({ "n" }, "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover", noremap = true, buffer = bufnr })
    vim.keymap.set(
        { "n" },
        "<leader>la",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        { desc = "Code Action", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>lr",
        "<cmd>Telescope lsp_references theme=get_ivy initial_mode=normal<CR>",
        { desc = "References", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>lt",
        "<cmd>Telescope lsp_type_definitions theme=get_ivy initial_mode=normal<CR>",
        { desc = "Type Definitions", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>ld",
        "<cmd>Telescope lsp_definitions theme=get_ivy initial_mode=normal<CR>",
        { desc = "Definitions", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>li",
        "<cmd>Telescope lsp_implementations theme=get_ivy initial_mode=normal<CR>",
        { desc = "Implementations", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>lS",
        "<cmd>Telescope lsp_workspace_symbols<CR>",
        { desc = "Workspace Symbols", noremap = true, buffer = bufnr }
    )
    vim.keymap.set({ "n" }, "<leader>lE", function()
        require("telescope.builtin").diagnostics({
            theme = "dropdown",
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.6 },
        })
    end, { desc = "Workspace", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>le", function()
        require("telescope.builtin").diagnostics({
            bufnr = 0,
            theme = "dropdown",
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.6 },
        })
    end, { desc = "Buff", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lR", function()
        utils.lsp_rename()
    end, { desc = "Rename Symbol", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "]d", vim.diagnostic.goto_next)
    vim.keymap.set({ "n" }, "[d", vim.diagnostic.goto_prev)

    -- toggle inlay_hint
    vim.keymap.set({ "n" }, "<leader>lH", function()
        local hint_flag = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(hint_flag)
    end, { desc = "Virtual Hints", noremap = true, silent = false, buffer = bufnr })

    -- lsp lines globally
    local lsp_lines_enable = false
    vim.keymap.set("n", "<leader>lh", function()
        if not lsp_lines_enable then
            M.default_diagnostic_config.virtual_text = false
            M.default_diagnostic_config.virtual_lines = true
            lsp_lines_enable = true
        else
            M.default_diagnostic_config.virtual_text = {
                source = "if_many",
                -- prefix = ' ',
                prefix = " ",
                -- prefix = "⏺ "
            }
            M.default_diagnostic_config.virtual_lines = false
            lsp_lines_enable = false
        end
        vim.diagnostic.config(M.default_diagnostic_config)
    end, { desc = "Toggle HlChunk", noremap = true })

    -- enable lsplines for curr line
    local lsp_lines_curr_line_enabled = false
    vim.keymap.set("n", "<F13>l", function()
        if lsp_lines_enable then
            return
        end
        if not lsp_lines_curr_line_enabled then
            M.default_diagnostic_config.virtual_lines = { only_current_line = true }
            lsp_lines_curr_line_enabled = true
        else
            M.default_diagnostic_config.virtual_lines = false
            lsp_lines_curr_line_enabled = false
        end
        vim.diagnostic.config(M.default_diagnostic_config)
    end, { desc = "HlChunk .", noremap = true })
    -- autocmd to disable per line HlChunk
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMoved", "CursorMovedI" }, {
        group = vim.api.nvim_create_augroup("Diaable_hlchunk", { clear = true }),
        callback = function()
            if M.default_diagnostic_config.virtual_lines then
                M.default_diagnostic_config.virtual_lines = false
                M.default_diagnostic_config.virtual_text = {
                    source = "if_many",
                    -- prefix = ' ',
                    prefix = " ",
                    -- prefix = "⏺ "
                }
                vim.diagnostic.config(M.default_diagnostic_config)
                lsp_lines_curr_line_enabled = false
            end
        end,
    })

    -- Code Runner
    vim.keymap.set("n", "<leader>rc", function()
        local file_type = vim.bo.filetype
        utils.code_runner(file_type, "horizontal") -- float, window, horizontal, vertical
    end, { silent = true, desc = "Run Code" })

    vim.keymap.set("n", "<F4>", function()
        local file_type = vim.bo.filetype
        require("pluginSetups.toggleTermConfig").code_runner(file_type)
    end, { noremap = true, silent = true, desc = "Run Code" })

    -- jump lsp word
    -- vim.keymap.set({ "n" }, "]w", function() words.jump(1, false) end,
    --     { desc = "next LSP word", noremap = true, buffer = bufnr })
    -- vim.keymap.set({ "n" }, "[w", function() words.jump(-1, false) end,
    --     { desc = "prev LSP word", noremap = true, buffer = bufnr })

    -- ouline
    vim.keymap.set({ "n" }, "<leader>ls", "<cmd>Outline<CR>", { desc = "Document Symbols", noremap = true })
end

return M
