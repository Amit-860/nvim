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
            click = "v:lua.ScSa",
        },
        {
            sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = true },
            click = "v:lua.ScSa"
        },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa", },
        {
            sign = { namespace = { 'gitsigns' }, maxwidth = 1, colwidth = 1, auto = true, },
            click = 'v:lua.ScSa'
        },
        {
            text = {
                function(args)
                    args.fold.close = ""
                    args.fold.open = ""
                    args.fold.sep = " "
                    return builtin.foldfunc(args)
                end,
            },
            condition = {
                function()
                    return vim.o.foldcolumn ~= "0"
                end,
            },
            click = "v:lua.ScFa",
        },
        {
            sign = { name = { ".*" }, maxwidth = 1, colwidth = 1 },
            click = "v:lua.ScSa"
        },
    }
})
