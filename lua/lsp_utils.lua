local icons = require('icons')
local utils = require("utils")
local default_diagnostic_config = {
    signs = {
        active = true,
        values = {
            { name = "DiagnosticSignError", text = icons.diagnostics.Error },
            { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
            { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
            { name = "DiagnosticSignInfo",  text = icons.diagnostics.Information },
        },
    },
    virtual_text = {
        source = "if_many",
        -- prefix = ' ',
        prefix = ' ',
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

local open_diagnostics_float = function()
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
            "InsertLeave"
        },
    })
end

vim.diagnostic.config(default_diagnostic_config)

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


local M = {}

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
local supports_method = {}

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
local function on_dynamic_capability(fn, opts)
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
local function check_methods(client, buffer)
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
    for method, clients in pairs(supports_method) do
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
    supports_method[method] = supports_method[method] or setmetatable({}, { __mode = "k" })
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
    M.lsp_on_attach(check_methods)
    on_dynamic_capability(check_methods)
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
    if inlay_hint_flag and client.supports_method "textDocument/inlayHint" then
        vim.lsp.inlay_hint.enable(false)
    end

    -- NOTE: code_lens
    local code_lens_flag = false
    -- if client.server_capabilities.codeLensProvider then
    if code_lens_flag and client.supports_method "textDocument/codeLens" then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end

    -- NOTE: LSP word highlight -----------------------------------------------------------------
    local words = {}
    local _, cmp = pcall(require, 'cmp')
    words.enabled = false
    words.ns = vim.api.nvim_create_namespace("vim_lsp_references")

    ---@param opts? {enabled?: boolean}
    function words.setup(opts)
        opts = opts or {}
        if not opts.enabled then
            return
        end
        words.enabled = true
        local handler = vim.lsp.handlers["textDocument/documentHighlight"]
        vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
            if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
                return
            end
            vim.lsp.buf.clear_references()
            return handler(err, result, ctx, config)
        end
        if client.supports_method "textDocument/documentHighlight" then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
                group = vim.api.nvim_create_augroup("lsp_word_" .. bufnr, { clear = true }),
                buffer = bufnr,
                callback = function(ev)
                    if not ({ words.get() })[2] then
                        if ev.event:find("CursorMoved") then
                            vim.lsp.buf.clear_references()
                        elseif not cmp.visible() then
                            vim.lsp.buf.document_highlight()
                        end
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ "InsertCharPre" }, {
                group = vim.api.nvim_create_augroup("lsp_word_clear_" .. bufnr, { clear = true }),
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.clear_references()
                end,
            })
        end
    end

    ---@return LspWord[] words, number? current
    function words.get()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local current, ret = nil, {} ---@type number?, LspWord[]
        for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, words.ns, 0, -1, { details = true })) do
            local w = {
                from = { extmark[2] + 1, extmark[3] },
                to = { extmark[4].end_row + 1, extmark[4].end_col },
            }
            ret[#ret + 1] = w
            if cursor[1] >= w.from[1] and cursor[1] <= w.to[1] and cursor[2] >= w.from[2] and cursor[2] <= w.to[2] then
                current = #ret
            end
        end
        return ret, current
    end

    -- INFO:
    words.setup({ enabled = true })

    ---@param count number
    ---@param cycle? boolean
    function words.jump(count, cycle)
        local word, idx = words.get()
        if not idx then
            return
        end
        idx = idx + count
        if cycle then
            idx = (idx - 1) % #word + 1
        end
        local target = word[idx]
        if target then
            vim.api.nvim_win_set_cursor(0, target.from)
        end
    end

    ---INFO: reaname ----------------------------------------------------------------------------------
    ---@param from string
    ---@param to string
    ---@param rename? fun()
    local function on_rename(from, to, rename)
        local changes = {
            files = { {
                oldUri = vim.uri_from_fname(from),
                newUri = vim.uri_from_fname(to),
            } }
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

    vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
            on_rename(event.data.from, event.data.to, function()
                vim.cmd.edit(event.data.to)
                vim.api.nvim_buf_delete(buf, { force = true })
            end)
        end,
    })

    local _, api = pcall(require, "nvim-tree.api")
    local Event = api.events.Event
    api.events.subscribe(Event.NodeRenamed, function(data)
        on_rename(data.old_name, data.new_name, function()
            vim.cmd.edit(data.new_name)
            vim.api.nvim_buf_delete(buf, { force = true })
        end)
    end)


    -- NOTE: lsp keymap ---------------------------------------------------------------------------------
    -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true, buffer=bufnr })
    vim.keymap.set({ "n", "i" }, "<F13>k", open_diagnostics_float,
        { desc = "Signature Help", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n", "i" }, "<M-i>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        { desc = "Signature Help", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
        { desc = "Hover", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
        { desc = "Code Action", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lr",
        "<cmd>Telescope lsp_references theme=get_ivy initial_mode=normal<CR>",
        { desc = "References", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lt",
        "<cmd>Telescope lsp_type_definitions theme=get_ivy initial_mode=normal<CR>",
        { desc = "Type Definitions", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>ld",
        "<cmd>Telescope lsp_definitions theme=get_ivy initial_mode=normal<CR>",
        { desc = "Definitions", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>li",
        "<cmd>Telescope lsp_implementations theme=get_ivy initial_mode=normal<CR>",
        { desc = "Implementations", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>",
        { desc = "Workspace Symbols", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lD",
        "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy initial_mode=normal<CR>",
        { desc = "Diagnostics", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lf", function() vim.lsp.buf.format() end,
        { desc = "Format", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>lR", function()
        require('utils').lsp_rename()
    end, { desc = "Rename Symbol", noremap = true, buffer = bufnr })

    -- toggle inlay_hint
    vim.keymap.set({ "n" }, "<leader>lH",
        function()
            local hint_flag = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(hint_flag)
        end, { desc = "Virtual Hints", noremap = true, silent = false, buffer = bufnr })

    -- lsp lines globally
    local lsp_lines_enable = false
    vim.keymap.set("n", "<leader>lh",
        function()
            if not lsp_lines_enable then
                default_diagnostic_config.virtual_text = false
                default_diagnostic_config.virtual_lines = true
                lsp_lines_enable = true
            else
                default_diagnostic_config.virtual_text = {
                    source = "if_many",
                    -- prefix = ' ',
                    prefix = ' ',
                    -- prefix = "⏺ "
                }
                default_diagnostic_config.virtual_lines = false
                lsp_lines_enable = false
            end
            vim.diagnostic.config(default_diagnostic_config)
        end, { desc = "Toggle HlChunk", noremap = true }
    )

    -- enable lsplines for curr line
    local lsp_lines_curr_line_enabled = false
    vim.keymap.set("n", "<F13>l",
        function()
            if lsp_lines_enable then return end
            if not lsp_lines_curr_line_enabled then
                default_diagnostic_config.virtual_lines = { only_current_line = true }
                lsp_lines_curr_line_enabled = true
            else
                default_diagnostic_config.virtual_lines = false
                lsp_lines_curr_line_enabled = false
            end
            vim.diagnostic.config(default_diagnostic_config)
        end, { desc = "HlChunk .", noremap = true }
    )
    -- autocmd to disable per line HlChunk
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMoved", "CursorMovedI" }, {
        group = vim.api.nvim_create_augroup("Diaable_hlchunk", { clear = true }),
        callback = function()
            if default_diagnostic_config.virtual_lines then
                default_diagnostic_config.virtual_lines = false
                default_diagnostic_config.virtual_text = {
                    source = "if_many",
                    -- prefix = ' ',
                    prefix = ' ',
                    -- prefix = "⏺ "
                }
                vim.diagnostic.config(default_diagnostic_config)
                lsp_lines_curr_line_enabled = false
            end
        end,
    })

    -- Code Runner
    vim.keymap.set("n", "<leader>rc", function()
        local file_type = vim.bo.filetype
        utils.code_runner(file_type, "horizontal") -- float, window, horizontal, vertical
    end, { silent = true, desc = "Run Code", })

    vim.keymap.set("n", "<F4>", function()
        local file_type = vim.bo.filetype
        require('pluginSetups.toggleTermConfig').code_runner(file_type)
    end, { noremap = true, silent = true, desc = "Run Code", })


    -- jump lsp word
    vim.keymap.set({ "n" }, "]w", function() words.jump(1, false) end,
        { desc = "next LSP word", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "[w", function() words.jump(-1, false) end,
        { desc = "prev LSP word", noremap = true, buffer = bufnr })

    -- ouline
    vim.keymap.set({ "n" }, "<leader>ls", "<cmd>Outline<CR>",
        { desc = "Document Symbols", noremap = true, })
end


-- NOTE : lsp autocmds
local lsp_attach_aug = vim.api.nvim_create_augroup("lsp_attach_aug", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        M.on_attach(client, 0)
        vim.b.minicursorword_disable = true
    end,
    group = lsp_attach_aug,
})

return M
