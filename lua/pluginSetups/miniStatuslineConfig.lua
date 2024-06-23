local grapple            = require('grapple')
local get_grapple_status = function(bufnr)
    if grapple.exists(bufnr) then
        -- return grapple.statusline()
        return "󰛢 " .. grapple.name_or_index(bufnr)
    end
    return ""
end

local noice              = require("noice")
local get_marco_status   = function()
    if noice.api.statusline.mode.has then
        return noice.api.statusline.mode.get()
    end
    return ""
end

require('mini.statusline').setup({
    content = {
        active = function(bufnr)
            local mode, mode_hl  = MiniStatusline.section_mode({ trunc_width = 120 })
            local git            = MiniStatusline.section_git({ trunc_width = 40 })
            local diff           = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics    = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp            = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename       = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo       = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location       = MiniStatusline.section_location({ trunc_width = 75 })
            local search         = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local grapple_status = get_grapple_status(bufnr)
            local macro          = get_marco_status()

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                 strings = { mode } },
                { hl = "MacroRecording",        strings = { macro } },
                { hl = "MarkStatusLine",        strings = { grapple_status } },
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
