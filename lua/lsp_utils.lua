local M = {}
local utils = require("utils")
local lsp_options = require("lsp_opts")

local lsp_feature_opts = lsp_options.lsp_feature_opts
local virtual_text_signs = lsp_options.virtual_text_signs
local default_diagnostic_config = lsp_options.default_diagnostic_config
local capabilities_opts = lsp_options.default_capabilities_opts
local open_diagnostics_float = lsp_options.open_diagnostics_float

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

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_lsp_attach(on_attach, name)
    return vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (not name or client.name == name) then
                -- INFO: add any thing here if it has to attach to all lsp_attached buffer
                -- Example : - below keymap will attach to all lsp attached buffers other
                -- wise add it to M.on_attach func if need to attach only to specific lsp/buffers
                -- and pass that on_attach func to LSP during setup
                -- vim.keymap.set("n", "<leader>m", function() end, {})
                return on_attach(client, buffer)
            end
        end,
    })
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
    M.on_lsp_attach(M._check_methods)
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

-- INFO: Global LSP setup ------------------------------------------------------------------
function M.global_lsp_setup()
    if lsp_feature_opts.code_lens.enabled and vim.lsp.codelens then
        M.on_supports_method("textDocument/codeLens", function(client, buffer)
            if not vim.tbl_contains(lsp_feature_opts.code_lens.exclude, vim.bo[buffer].filetype) then
                vim.lsp.codelens.refresh()
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    buffer = buffer,
                    callback = vim.lsp.codelens.refresh,
                })
            end
        end)
    end

    if lsp_feature_opts.inlay_hints.enabled then
        M.on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
                vim.api.nvim_buf_is_valid(buffer)
                and vim.bo[buffer].buftype == ""
                and not vim.tbl_contains(lsp_feature_opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
        end)
    end

    local _, nvim_tree_api = pcall(require, "nvim-tree.api")
    M.on_supports_method("workspace/willRenameFiles", function(client, buffer)
        local function on_rename(from, to, rename)
            local changes = {
                files = { { oldUri = vim.uri_from_fname(from), newUri = vim.uri_from_fname(to) } },
            }

            local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end

            if rename then
                rename()
            end

            if client.supports_method("workspace/didRenameFiles") then
                client.notify("workspace/didRenameFiles", changes)
            end
        end

        local Event = nvim_tree_api.events.Event
        nvim_tree_api.events.subscribe(Event.NodeRenamed, function(data)
            on_rename(data.old_name, data.new_name, function() end)
        end)
    end)

    vim.diagnostic.config(default_diagnostic_config)

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
end

-- INFO: on_attach func =========================================================================
M.on_attach = function(client, bufnr)
    -- NOTE: lsp keymap ---------------------------------------------------------------------------------
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
                border = vim.g.win_border,
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
                border = vim.g.win_border,
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
        -- "<cmd>Telescope lsp_workspace_symbols<CR>",
        function()
            require("snacks").picker.lsp_symbols()
        end,
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
            default_diagnostic_config.virtual_text = false
            default_diagnostic_config.virtual_lines = true
        else
            default_diagnostic_config.virtual_text = virtual_text_signs
            default_diagnostic_config.virtual_lines = false
        end
        lsp_lines_enable = not lsp_lines_enable
        vim.diagnostic.config(default_diagnostic_config)
    end, { desc = "Toggle HlChunk", noremap = true })

    -- autocmd to disable HlChunk
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMoved", "CursorMovedI" }, {
        group = vim.api.nvim_create_augroup("Diaable_hlchunk", { clear = true }),
        callback = function()
            if default_diagnostic_config.virtual_lines then
                default_diagnostic_config.virtual_lines = false
                default_diagnostic_config.virtual_text = virtual_text_signs
                vim.diagnostic.config(default_diagnostic_config)
                lsp_lines_enable = false
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

    -- open_diagnostics_float
    vim.keymap.set({ "n" }, "<F13>k", open_diagnostics_float, { desc = "Open diagnostics float", noremap = true })
end

return M
