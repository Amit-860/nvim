local kmap = vim.keymap.set
local ucmd = vim.api.nvim_create_user_command
local Menu = require("nui.menu")
-- INFO: add list of file with name = path ============================================================================
local json_files = {
    large = vim.fn.expand("$HOME/Downloads/large-file.json")
}
-- ====================================================================================================================

local function buf_text(bufnr)
    if bufnr == nil then
        bufnr = vim.api.nvim_win_get_buf(0)
    end
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), true)
    local text = ''
    for _, line in ipairs(lines) do
        text = text .. line .. '\n'
    end
    return text
end

local function set_buf_text(text, bufnr)
    if bufnr == nil then
        bufnr = vim.fn.bufnr('%')
    end

    if type(text) == 'string' then
        text = vim.fn.split(text, '\n')
    end

    vim.api.nvim_buf_set_lines(
        bufnr,
        0,
        -1,
        false,
        text
    )
end

local function is_valid_path(path)
    local path_len = string.len(path)
    if path_len < 5 then
        return false
    end
    if string.sub(path, path_len - 5) == "json" then
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

    if (not modified) and fname ~= nil then
        -- the following should be faster as it lets jq read the file contents
        print("path")
        return vim.fn.system({ 'jq', filter, fname })
    else
        print('buff')
        local json = buf_text(json_bufnr)
        return vim.fn.system({ 'jq', filter }, json)
    end
end

local result_bufnr = nil
local function Jq_command(horizontal, filter)
    local splitcmd = 'vnew'

    if horizontal == true then
        splitcmd = 'new'
    end

    local json_bufnr = vim.fn.bufnr()
    local json_winnr = vim.fn.bufwinid(json_bufnr)
    if vim.bo.filetype ~= 'json' then
        return
    end

    if result_bufnr == nil or not vim.fn.bufexists(result_bufnr) then
        vim.cmd(splitcmd)
        vim.cmd 'set filetype=text'
        result_bufnr = vim.fn.bufnr()
    end
    set_buf_text(jq_filter(json_bufnr, filter, nil), result_bufnr)
    vim.fn.win_gotoid(json_winnr)
end

local file = nil
local jq_win = {}
function Jq_file_command(horizontal)
    local splitcmd = 'vnew'

    if horizontal == true then
        splitcmd = 'new'
    end

    if not file then
        return
    end

    vim.cmd('tabnew')
    vim.cmd 'set filetype=conf'

    set_buf_text('# JQ filter: press <CR> to execute it\n\n.')
    vim.cmd 'normal!G'
    local jq_bufnr = vim.fn.bufnr()
    local jq_winnr = vim.fn.bufwinid(jq_bufnr)

    vim.cmd(splitcmd)
    local r_result_bufnr = vim.fn.bufnr()
    local r_result_winnr = vim.fn.bufwinid(r_result_bufnr)

    vim.fn.win_gotoid(jq_winnr)

    -- setup keybinding autocmd in the filter buffer:
    kmap(
        'n',
        '<CR>',
        function()
            local filter = buf_text(jq_bufnr)
            set_buf_text(jq_filter(nil, filter, file), r_result_bufnr)
        end,
        { buffer = jq_bufnr }
    )

    jq_win.jq_bufnr = jq_bufnr
    jq_win.jq_winnr = jq_winnr
    jq_win.r_result_bufnr = r_result_bufnr
    jq_win.r_result_winnr = r_result_winnr
end

local function create_menu(file_list)
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
            size = { width = 38, height = 28, },
            border = {
                style = "single",
                text = { top = "[Select file]", top_align = "center", },
            },
            win_options = {
                winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            },
        },
        {
            lines = f_list,
            max_width = 32,
            keymap = {
                focus_next = { "j", "<Down>", "<Tab>" },
                focus_prev = { "k", "<Up>", "<S-Tab>" },
                close = { "<Esc>", "<C-c>" },
                submit = { "<CR>", "<Space>" },
            },
            on_close = function() print("Menu Closed!") end,
            on_submit = function(item)
                file = map[item.text]
                Jq_file_command(false)
            end,
        })

    menu:mount()
end

ucmd('Jq', function(opts)
    Jq_command(false, opts.fargs[1])
end, { nargs = 1 })

ucmd('Jqf', function(args)
    if args.bang and jq_win.jq_bufnr and jq_win.r_result_bufnr then
        vim.cmd.bwipeout({ count = jq_win.jq_bufnr, bang = true })
        vim.cmd.bwipeout({ count = jq_win.r_result_bufnr, bang = true })
    else
        create_menu(json_files)
    end
end, { desc = "Jq File", bang = true })
