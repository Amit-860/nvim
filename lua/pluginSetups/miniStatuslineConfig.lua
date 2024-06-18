local statusline = require('arrow.statusline')
local get_arrow_status = function(bufnr)
    if statusline.is_on_arrow_file(bufnr) then
        return statusline.text_for_statusline_with_icons(bufnr)
    end
    return ""
end

require('mini.statusline').setup({
    content = {
        active = function(bufnr)
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 40 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location      = MiniStatusline.section_location({ trunc_width = 75 })
            local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local arrow_status  = get_arrow_status(bufnr)

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                 strings = { mode } },
                { hl = "MarkStatusLine",        strings = { arrow_status } },
                { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                '%<', -- Mark general truncate point
                { hl = 'MiniStatuslineFilename', strings = { filename } },
                '%=', -- End left alignment
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                { hl = "CmpItemKindFunction",    strings = { search } },
                { hl = mode_hl,                  strings = { location } },
            })
        end,
    },
    use_icons = true,
    set_vim_settings = true,
})
