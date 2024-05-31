M = {}
local builtin = require('telescope.builtin')

M.smart_find_file = function()
    local opts = {}
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

M.zoxide = function()
    vim.ui.input({ prompt = "Pattern : " }, function(input)
        vim.cmd("Z " .. input)
    end)
end

M.find_and_replace = function()
    local word = nil
    vim.ui.input({ prompt = 'Find : ' }, function(input)
        word = input
    end)
    if word then
        vim.ui.input({ prompt = "Replace : " }, function(input)
            vim.cmd(":%s/" .. word .. "/" .. input .. "/gc")
        end)
    end
end


return M
