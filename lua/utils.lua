M = {}

local prompt_input_cursor_pos = function(opts, on_submit)
    local Input = require('nui.input')
    local popup = {
        relative = 'cursor',
        position = {
            row = 1,
            col = 0,
        },
        size = {
            width = '25%',
        },
        border = {
            style = 'rounded',
            highlight = 'FloatBorder',
        },
        win_options = {
            winhighlight = 'NormalFloat:NormalFloat',
        }
    }
    local input = Input(popup, {
        prompt = opts.prompt,
        default_value = opts.default_value,
        on_submit = on_submit
    })

    input:mount()
    input:map('i', '<Esc>', input.input_props.on_close, { noremap = true })
    input:map('i', '<C-c>', input.input_props.on_close, { noremap = true })
end
M.prompt_input_cursor_pos = prompt_input_cursor_pos

M.smart_find_file = function(opts)
    local builtin = require('telescope.builtin')
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

M.zoxide = function()
    vim.ui.input({ prompt = "Pattern : " }, function(input)
        if input then
            vim.cmd("Z " .. input)
        else
            return
        end
    end)
end

M.find_and_replace = function()
    local word = nil
    vim.ui.input({ prompt = 'Find : ' }, function(input)
        word = input
    end)
    if word then
        vim.ui.input({ prompt = "Replace : " }, function(input)
            if not input then return end
            vim.cmd(":%s/" .. word .. "/" .. input .. "/gc")
        end)
    else
        return
    end
end

local get_visual_selection = function()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end
M.get_visual_selection = get_visual_selection

M.replace = function()
    local word = nil
    word = get_visual_selection()
    if word then
        vim.ui.input({ prompt = "Replace : " }, function(input)
            if not input then return end
            vim.cmd(":%s/" .. word .. "/" .. input .. "/gc")
        end)
    else
        return
    end
end

M.lsp_rename = function()
    local cursor_word = vim.fn.expand("<cword>")
    if not cursor_word then return end
    prompt_input_cursor_pos({ prompt = cursor_word .. " -> ", default_value = nil }, function(input)
        if not input then return end
        vim.lsp.buf.rename(input)
    end)
end

return M
