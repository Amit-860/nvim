local db = require('dashboard')
local utils = require('utils')
db.setup({
    theme = 'hyper',
    change_to_vcs_root = true,
    disable_move = true,
    config = {
        week_header = {
            enable = true,
        },
        shortcut = {
            {
                desc = '󰊳 Update',
                group = '@property',
                action = 'Lazy update',
                key = 'U'
            },
            {
                desc = ' Files',
                icon_hl = '@variable',
                group = 'Label',
                action = function() utils.smart_find_file({}) end,
                key = 'F',
            },
            {
                desc = ' Projects',
                group = 'DiagnosticHint',
                action = function() require 'telescope'.extensions.project.project { display_type = 'full' } end,
                key = 'P',
            },
            {
                desc = ' Configs',
                group = 'Number',
                action = function()
                    utils.smart_find_file({ find_command = { 'fd', '-H', '-E', '.git', '.', vim.fn.expand("$HOME/AppData/Local/nvim/") } })
                end,
                key = 'C',
            },
            {
                desc = ' Last',
                group = '@module',
                action = function() require('persistence').load({ last = true }) end,
                key = 'L',
            },
        },
    },
})

vim.api.nvim_set_hl(0, "DashboardProjectTitle", { fg = "#3279ce", bold = true })
vim.api.nvim_set_hl(0, "DashboardProjectTitleIcon", { fg = "#25a5a8", bold = true })
vim.api.nvim_set_hl(0, "DashboardProjectIcon", { fg = "#e1be66", bold = true })

vim.api.nvim_set_hl(0, "DashboardMruTitle", { link = "DashboardProjectTitle" })
vim.api.nvim_set_hl(0, "DashboardMruIcon", { link = "DashboardProjectTitleIcon" })
vim.api.nvim_set_hl(0, "DashboardMruShortCutIcon", { link = "DashboardProjectIcon" })
-- DashboardProjectTitle DashboardProjectTitleIcon DashboardProjectIcon
-- DashboardMruTitle DashboardMruIcon DashboardFiles DashboardShortCutIcon
