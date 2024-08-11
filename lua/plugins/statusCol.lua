return {
    "luukvbaal/statuscol.nvim",
    event = { "BufNewFile", "BufReadPre" },
    dependencies = {
        "lewis6991/gitsigns.nvim",
    },
    opts = function()
        local builtin = require('statuscol.builtin')
        local statuscol_opts = {
            ft_ignore = {
                'NvimTree',
                'toggleterm',
                'NeogitStatus',
                'help',
                'lazy'
            },
            bt_ignore = {
                'nofile',
                'terminal',
                'Neogit',
            },
            relculright = true,
            segments = {
                {
                    sign = { namespace = { "diagnostic/signs" }, name = { 'Dap' }, text = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
                    click = "v:lua.ScLa"
                },
                {
                    text = { " ", builtin.lnumfunc, },
                    condition = { true, builtin.non_empty },
                    click = "v:lua.ScLa",
                    auto = false
                },
                {
                    text = { " " },
                    click = 'v:lua.ScSa',
                    auto = false
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
        }

        return statuscol_opts
    end,
    config = function(_, opts)
        require("statuscol").setup(opts)
    end
}
