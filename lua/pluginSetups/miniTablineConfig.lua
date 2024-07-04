local mini_tabline = require('mini.tabline')

mini_tabline.setup({
    format = function(buf_id, label)
        local suffix = vim.bo[buf_id].modified and ' ' or ''
        return mini_tabline.default_format(buf_id, label) .. suffix
    end,
    tabpage_section = 'right'
})
