M = {}

M.smart_find_file = function()
    local builtin = require('telescope.builtin')
    local opts = {}
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

function M.getVisualSelection()
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

M.replace = function()
    local word = nil
    word = M.getVisualSelection()
    if word then
        vim.ui.input({ prompt = "Replace : " }, function(input)
            if not input then return end
            vim.cmd(":%s/" .. word .. "/" .. input .. "/gc")
        end)
    else
        return
    end
end


return M
