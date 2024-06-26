require('mini.ai').setup()
require('mini.cursorword').setup()
require('mini.files').setup({
    options = {
        use_as_default_explorer = true,
    },
})
require('mini.indentscope').setup()

-- require('mini.basics').setup({
--     options = { extra_ui = true, win_borders = 'double', },
--     mappings = { windows = true, }
-- })

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'CmpItemKindClass' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'CmpItemKindValue' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'CmpItemKindMethod' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'CmpItemKindText' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})
