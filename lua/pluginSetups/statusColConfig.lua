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
            sign = { namespace = { "diagnostic/signs" }, name = { 'Dap' }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScLa"
        },
        {
            text = { " ", builtin.lnumfunc, " " },
            condition = { true, builtin.non_empty },
            click = "v:lua.ScSa",
            auto = true
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
            auto = false,
            click = "v:lua.ScFa",
        },
        {
            sign = { name = { ".*" }, text = { ".*" }, maxwidth = 1, colwidth = 1 },
            click = "v:lua.ScFa",
            auto = true,
        },
    }
})
