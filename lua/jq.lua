local kmap = vim.keymap.set
local ucmd = vim.api.nvim_create_user_command

function buf_text(bufnr)
    if bufnr == nil then
        bufnr = vim.api.nvim_win_get_buf(0)
    end
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.api.nvim_buf_line_count(bufnr), true)
    local text = ''
    for i, line in ipairs(lines) do
        text = text .. line .. '\n'
    end
    return text
end

function set_buf_text(text, bufnr)
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

function jq_filter(json_bufnr, jq_filter, fpath)
    -- spawn jq and pipe in json, returning the output text
    local fname = nil
    local modified = nil
    if json_bufnr then
        modified = vim.bo[json_bufnr].modified
        fname = vim.fn.bufname(json_bufnr)
    end

    if fpath then
        fname = fpath
    end

    if (not modified) and fname ~= '' then
        -- the following should be faster as it lets jq read the file contents
        return vim.fn.system({ 'jq', jq_filter, fname })
    else
        local json = buf_text(json_bufnr)
        return vim.fn.system({ 'jq', jq_filter }, json)
    end
end

local result_bufnr = nil

function Jq_command(horizontal, filter)
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

    -- vim.cmd(splitcmd)
    -- vim.cmd 'set filetype=conf'
    -- set_buf_text('# JQ filter: press <CR> to execute it\n\n.')
    -- vim.cmd 'normal!G'
    -- local jq_bufnr = vim.fn.bufnr()
    -- local jq_winnr = vim.fn.bufwinid(jq_bufnr)

    -- vim.fn.win_gotoid(jq_winnr)

    set_buf_text(jq_filter(json_bufnr, filter, nil), result_bufnr)
    vim.fn.win_gotoid(json_winnr)

    -- setup keybinding autocmd in the filter buffer:
    -- kmap(
    --     'n',
    --     '<CR>',
    --     function()
    --         local filter = buf_text(jq_bufnr)
    --         set_buf_text(jq_filter(json_bufnr, filter), result_bufnr)
    --     end,
    --     { buffer = jq_bufnr }
    -- )
end

local fpath = vim.fn.expand("$HOME/Downloads/large-file.json")
function Jq_file_command(horizontal, filter)
    local splitcmd = 'vnew'

    if horizontal == true then
        splitcmd = 'new'
    end

    -- fpath = nil
    if not fpath then
        -- show list to select fpath
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
            set_buf_text(jq_filter(nil, filter, fpath), r_result_bufnr)
        end,
        { buffer = jq_bufnr }
    )
end

ucmd('Jq', function(opts)
    Jq_command(false, opts.fargs[1])
end, { nargs = 1 })

ucmd('Jqq', function()
    Jq_file_command(false)
end, {})

ucmd('Jqhorizontal', function()
    Jq_command(true)
end, {})
