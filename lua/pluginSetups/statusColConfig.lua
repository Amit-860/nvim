local builtin = require('statuscol.builtin')
require("statuscol").setup({
    ft_ignore = {
        'NvimTree',
        'toggleterm',
        'NeogitStatus'
    },
    bt_ignore = {
        'nofile',
        'terminal',
    },
    relculright = true,
    segments = {
        {
            sign = { name = { ".*" }, text = { ".*" }, },
            click = "v:lua.ScLa",
        },
        {
            sign = { namespace = { "diagnostic/signs" }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScSa"
        },
        {
            text = { " ", builtin.lnumfunc, " " },
            click = "v:lua.ScSa",
        },
        {
            sign = { namespace = { 'gitsigns' }, maxwidth = 1, colwidth = 1, auto = false, },
            click = 'v:lua.ScSa'
        },
        {
            text = {
                function(args)
                    local icons = require('icons')
                    args.fold.close = icons.ui.Right
                    args.fold.open = icons.ui.Down
                    args.fold.sep = " "
                    return builtin.foldfunc(args)
                end,
            },
            condition = {
                function()
                    return vim.o.foldcolumn ~= "0"
                end,
            },
            auto = false,
            click = "v:lua.ScFa",
        },
        {
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 1 },
            click = "v:lua.ScFa"
        },
    }
})
