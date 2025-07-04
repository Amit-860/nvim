local kmap = vim.keymap.set
local ucmd = vim.api.nvim_create_user_command
local Menu = require("nui.menu")
local q = require("local.get_query_under_cursor")

-- INFO: add list of file with name = path ============================================================================
local json_files = {
    large = vim.fn.expand("$HOME/Downloads/large-file.json"),
}
-- ====================================================================================================================

local function buf_text(bufnr)
    if bufnr == nil then
        bufnr = vim.api.nvim_win_get_buf(0)
    end
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), true)
    local text = ""
    for _, line in ipairs(lines) do
        text = text .. line .. "\n"
    end
    return text
end

local function set_buf_text(text, bufnr)
    if bufnr == nil then
        bufnr = vim.fn.bufnr("%")
    end

    if type(text) == "string" then
        text = vim.fn.split(text, "\n")
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, text)
end

local function is_valid_path(path)
    local path_len = string.len(path)
    if path_len < 5 then
        return false
    end
    if string.sub(path, path_len - 3) == "json" then
        return true
    end
    return false
end

local function jq_filter(json_bufnr, filter, fpath)
    -- spawn jq and pipe in json, returning the output text
    local fname = nil
    local modified = nil
    if json_bufnr then
        modified = vim.bo[json_bufnr].modified
        fname = vim.fn.bufname(json_bufnr)
        if not is_valid_path(fname) then
            fname = nil
        end
    end

    if fpath then
        fname = fpath
    end
    if (not modified) or fname ~= nil then
        -- the following should be faster as it lets jq read the file contents
        return vim.fn.system({ "jq", filter, fname })
    else
        local json = buf_text(json_bufnr)
        return vim.fn.system({ "jq", filter }, json)
    end
end

local result_bufnr = nil
local function Jq_command(horizontal, filter)
    local splitcmd = "vnew"
    if horizontal == true then
        splitcmd = "new"
    end

    local json_bufnr = vim.fn.bufnr()
    local json_winnr = vim.fn.bufwinid(json_bufnr)

    if result_bufnr == nil or not vim.fn.bufexists(result_bufnr) then
        -- Buffer doesn't exist, create new
        vim.cmd(splitcmd)
        vim.cmd("set filetype=text")
        result_bufnr = vim.fn.bufnr()
    else
        -- Check if buffer is visible in any window [[4]][[5]]
        local existing_win = vim.fn.bufwinnr(result_bufnr)
        if existing_win == -1 then
            -- Buffer exists but isn't visible, create new split
            vim.cmd(splitcmd)
            vim.cmd("buffer " .. result_bufnr)
        else
            -- Buffer is already visible, switch to its window
            vim.fn.win_gotoid(existing_win)
        end
    end

    -- Update buffer content and return focus to original window
    set_buf_text(jq_filter(json_bufnr, filter, nil), result_bufnr)
    vim.fn.win_gotoid(json_winnr)
end

local function zq_filter(command)
    return vim.fn.system(command)
end

local function prepare_zq_query(args_table, ex_file)
    local c = q.get_current_query_with_file_name()

    local command = { "super" }
    for _, v in ipairs(args_table) do
        table.insert(command, v)
    end

    table.insert(command, "-c")
    table.insert(command, c.query)

    if c.query ~= "" and (c.filename ~= "" or ex_file ~= nil) then
        if ex_file == nil then
            table.insert(command, vim.fn.expand(c.filename))
        else
            table.insert(command, vim.fn.expand(ex_file))
        end
        return command
    end
end

local function zq_command(horizontal, args_table)
    local splitcmd = "vnew"
    if horizontal == true then
        splitcmd = "new"
    end

    local zed_bufnr = vim.fn.bufnr()
    local zed_winnr = vim.fn.bufwinid(zed_bufnr)

    local command = prepare_zq_query(args_table, nil)
    -- print(vim.inspect(command))

    if command == nil then
        return
    end

    if result_bufnr == nil or not vim.fn.bufexists(result_bufnr) then
        -- Buffer doesn't exist, create new
        vim.cmd(splitcmd)
        vim.cmd("set filetype=text")
        result_bufnr = vim.fn.bufnr()
    else
        -- Check if buffer is visible in any window [[4]][[5]]
        local existing_win = vim.fn.bufwinnr(result_bufnr)
        if existing_win == -1 then
            -- Buffer exists but isn't visible, create new split
            vim.cmd(splitcmd)
            vim.cmd("buffer " .. result_bufnr)
        else
            -- Buffer is already visible, switch to its window
            vim.fn.win_gotoid(existing_win)
        end
    end

    -- execute zq query and public result
    set_buf_text(zq_filter(command), result_bufnr)
    vim.fn.win_gotoid(zed_winnr)
end

local file = nil
local jq_win = {}
function Jq_file_command(horizontal, tool)
    local splitcmd = "vnew"

    if horizontal == true then
        splitcmd = "new"
    end

    if not file then
        return
    end

    vim.cmd("tabnew")
    vim.cmd("set filetype=conf")

    -- set_buf_text("# JQ filter: press <CR> to execute it\n\n.")
    vim.cmd("normal!G")
    local jq_bufnr = vim.fn.bufnr()
    local jq_winnr = vim.fn.bufwinid(jq_bufnr)

    vim.cmd(splitcmd)
    local r_result_bufnr = vim.fn.bufnr()
    local r_result_winnr = vim.fn.bufwinid(r_result_bufnr)

    vim.fn.win_gotoid(jq_winnr)

    -- setup keybinding autocmd in the filter buffer:
    kmap("n", "<CR>", function()
        if tool == "jq" then
            local filter = buf_text(jq_bufnr)
            set_buf_text(jq_filter(nil, filter, file), r_result_bufnr)
        else
            local filter = prepare_zq_query({ "-J" }, file)
            if filter == nil then
                return
            end
            -- print(vim.inspect(filter))
            set_buf_text(zq_filter(filter), r_result_bufnr)
        end
    end, { buffer = jq_bufnr })

    jq_win.jq_bufnr = jq_bufnr
    jq_win.jq_winnr = jq_winnr
    jq_win.r_result_bufnr = r_result_bufnr
    jq_win.r_result_winnr = r_result_winnr
end

local function create_menu(file_list, tool)
    local f_list = {}
    local map = {}
    local i = 1
    for fname, fpath in pairs(file_list) do
        local k = string.format("  %d. %s", i, fname)
        table.insert(f_list, Menu.item(k))
        map[k] = fpath
        i = i + 1
    end

    local menu = Menu({
        position = "50%",
        size = { width = 38, height = 28 },
        border = {
            style = "single",
            text = { top = "[Select file]", top_align = "center" },
        },
        win_options = {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
    }, {
        lines = f_list,
        max_width = 32,
        keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "<Esc>", "<C-q>" },
            submit = { "<CR>", "<Space>" },
        },
        on_close = function()
            print("Menu Closed!")
        end,
        on_submit = function(item)
            file = map[item.text]
            Jq_file_command(false, tool)
        end,
    })

    menu:mount()
end

-- NOTE : Jq ------------------------------------------------------------
ucmd("Jq", function(opts)
    Jq_command(false, opts.fargs[1])
end, { nargs = 1 })

ucmd("Jqh", function(opts)
    Jq_command(true, opts.fargs[1])
end, { nargs = 1 })

ucmd("Jqf", function(args)
    if args.bang and jq_win.jq_bufnr and jq_win.r_result_bufnr then
        vim.cmd.bwipeout({ count = jq_win.jq_bufnr, bang = true })
        vim.cmd.bwipeout({ count = jq_win.r_result_bufnr, bang = true })
    else
        create_menu(json_files, "jq")
    end
end, { desc = "Jq File", bang = true })

-- NOTE : Zq ------------------------------------------------------------
ucmd("Zq", function(opts)
    zq_command(false, opts.fargs)
end, { nargs = "*" })

ucmd("Zqh", function(opts)
    zq_command(true, opts.fargs)
end, { nargs = "*" })

ucmd("Zqf", function(args)
    if args.bang and jq_win.jq_bufnr and jq_win.r_result_bufnr then
        vim.cmd.bwipeout({ count = jq_win.jq_bufnr, bang = true })
        vim.cmd.bwipeout({ count = jq_win.r_result_bufnr, bang = true })
    else
        create_menu(json_files, "super")
    end
end, { desc = "Jq File", bang = true })

-- keymapping
vim.keymap.set({ "n" }, "<leader>rz", ":Zq -S<CR>", { desc = "Run Zq Query", noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>rj", ":Jq<CR>", { desc = "Run Jq Query", noremap = true, silent = true })
