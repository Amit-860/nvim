local M = {}
local icons = require("icons")
local utils = require("utils")

local capabilities_opts = {
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

M.lsp_capabilities = function()
    local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")
    local cmp_capabilities = {}
    if cmp_ok then
        cmp_capabilities = cmp.default_capabilities()
    end

    local blink_ok, blink = pcall(require, "blink.cmp")
    local blink_capabilities = {}
    if blink_ok then
        blink_capabilities = blink.get_lsp_capabilities()
    end

    local lsp_file_ops_ok, lsp_file_ops = pcall(require, "lsp-file-operations")
    local lsp_file_capabilities = {}
    if lsp_file_ops_ok then
        lsp_file_capabilities = lsp_file_ops.default_capabilities()
    end
    return vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        capabilities_opts,
        cmp_capabilities,
        blink_capabilities,
        lsp_file_capabilities
    )
end

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
        -- prefix = " ",
        -- prefix = " ",
        prefix = "⏺ ",
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

-- NOTE: ---------------------------------------------------------------------------------------

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

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

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
    M.on_attach(M._check_methods)
    M.on_dynamic_capability(M._check_methods)
end

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
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
    for method, clients in pairs(M._supports_method) do
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

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
    M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
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

function M.get_config(server)
    local configs = require("lspconfig.configs")
    return rawget(configs, server)
end

function M.get_raw_config(server)
    local ok, ret = pcall(require, "lspconfig.configs." .. server)
    if ok then
        return ret
    end
    return require("lspconfig.server_configurations." .. server)
end

-- INFO: on_attach func =========================================================================
M.on_attach = function(client, bufnr)
    -- NOTE: lsp keymap ---------------------------------------------------------------------------------
    -- vim.keymap.set("n", "<leader>l", "<nop>", { desc = "+LSP", noremap = true, buffer=bufnr })
    vim.keymap.set(
        { "n", "i" },
        "<M-i>",
        -- "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        function()
            vim.lsp.buf.signature_help()
        end,
        { desc = "Signature Help", noremap = true, buffer = bufnr }
    )
    -- vim.keymap.set({ "n" }, "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover", noremap = true, buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>la", function()
        -- vim.lsp.buf.code_action()
        local winopts = {
            relative = "cursor",
            height = 0.4,
            width = 0.35,
            border = vim.g.win_border,
            focusable = false,
            row = -math.floor(vim.o.lines * 0.2),
            col = 6,
            preview = {
                vertical = "up:60%",
                delay = 0,
            },
        }
        if vim.g.neovide then
            winopts.row = 1
            winopts.height = 0.25
            winopts.width = 0.6
            winopts.preview = {
                delay = 0,
                horizontal = "right:60%",
                layout = "horizontal",
                flip_columns = 100,
            }
        end

        require("fzf-lua").lsp_code_actions({
            winopts = winopts,
        })
    end, { desc = "Code Action", noremap = true, buffer = bufnr })
    vim.keymap.set(
        { "n" },
        "<leader>lr",
        -- "<cmd>Telescope lsp_references theme=get_ivy initial_mode=normal<CR>",
        function()
            require("telescope.builtin").lsp_references({
                bufnr = 0,
                theme = "dropdown",
                layout_strategy = "vertical",
                include_declaration = true,
                layout_config = { preview_height = 0.6 },
            })
        end,
        { desc = "References", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>lT",
        -- "<cmd>Telescope lsp_type_definitions theme=get_ivy initial_mode=normal<CR>",
        function()
            require("telescope.builtin").lsp_type_definitions({
                bufnr = 0,
                theme = "dropdown",
                layout_strategy = "vertical",
                include_declaration = true,
                layout_config = { preview_height = 0.6 },
            })
        end,
        { desc = "Type Definitions", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>ld",
        -- "<cmd>Telescope lsp_definitions theme=get_ivy initial_mode=normal<CR>",
        function()
            require("telescope.builtin").lsp_definitions({
                bufnr = 0,
                theme = "dropdown",
                layout_strategy = "vertical",
                include_declaration = true,
                layout_config = { preview_height = 0.6 },
            })
        end,
        { desc = "Definitions", noremap = true, buffer = bufnr }
    )
    vim.keymap.set(
        { "n" },
        "<leader>li",
        -- "<cmd>Telescope lsp_implementations theme=get_ivy initial_mode=normal<CR>",
        function()
            require("telescope.builtin").lsp_implementations({
                bufnr = 0,
                theme = "dropdown",
                layout_strategy = "vertical",
                include_declaration = true,
                layout_config = { preview_height = 0.6 },
            })
        end,
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
    -- vim.keymap.set({ "n" }, "<leader>lH", function()
    --     local hint_flag = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    --     vim.lsp.inlay_hint.enable(hint_flag)
    -- end, { desc = "Virtual Hints", noremap = true, silent = false, buffer = bufnr })

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
                -- prefix = " ",
                -- prefix = " ",
                prefix = "⏺ ",
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
                    -- prefix = " ",
                    -- prefix = " ",
                    prefix = "⏺ ",
                }
                vim.diagnostic.config(M.default_diagnostic_config)
                lsp_lines_curr_line_enabled = false
            end
        end,
    })

    -- Code Runner
    vim.keymap.set("n", "<leader>rc", function()
        local file_type = vim.bo.filetype
        -- local file_name = vim.api.nvim_buf_get_name(0)
        -- if file_type == "go" then
        --     utils.code_runner(file_type, "run .", "horizontal") -- float, window, horizontal, vertical
        -- else
        --     utils.code_runner(file_type, file_name, "horizontal") -- float, window, horizontal, vertical
        -- end
        vim.cmd("RunCode")
    end, { silent = true, desc = "Run Code" })

    vim.keymap.set("n", "<F4>", function()
        local file_type = vim.bo.filetype
        -- local file_name = vim.api.nvim_buf_get_name(0)
        -- if file_type == "go" then
        --     utils.code_runner(file_type, "run .", "horizontal") -- float, window, horizontal, vertical
        -- else
        --     utils.code_runner(file_type, file_name, "horizontal") -- float, window, horizontal, vertical
        -- end
        vim.cmd("RunCode")
    end, { noremap = true, silent = true, desc = "Run Code" })

    -- jump lsp word
    -- vim.keymap.set({ "n" }, "]w", function() words.jump(1, false) end,
    --     { desc = "next LSP word", noremap = true, buffer = bufnr })
    -- vim.keymap.set({ "n" }, "[w", function() words.jump(-1, false) end,
    --     { desc = "prev LSP word", noremap = true, buffer = bufnr })

    -- outline
    vim.keymap.set({ "n" }, "<leader>ls", "<cmd>Outline<CR>", { desc = "Document Symbols", noremap = true })
end

return M
