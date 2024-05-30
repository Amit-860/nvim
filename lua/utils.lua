M = {}
local builtin = require('telescope.builtin')

M.smart_find_file = function()
    local opts = {}
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

return M
