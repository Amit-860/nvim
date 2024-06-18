require('mini.ai').setup()
require('mini.comment').setup({
    mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = 'gc',

        -- Toggle comment on current line
        comment_line = '<leader>/',

        -- Toggle comment on visual selection
        comment_visual = '<leader>/',

        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- Works also in Visual mode if mapping differs from `comment_visual`
        textobject = 'gc',
    },
})
require('mini.cursorword').setup()
require('mini.files').setup()
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
