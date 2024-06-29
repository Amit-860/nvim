M = {}
-- vim.api.nvim_set_hl(0, "MatchParen", { bg = nil, fg = "#fffd00", underline = true, bold = true })
-- vim.api.nvim_set_hl(0, "MatchParen", { bg = "#4d5969", fg = "#ffffff", underline = false, bold = true })
vim.api.nvim_set_hl(0, "FindAndReplace", { bg = "#e95d5d", fg = "#131a24", bold = true })
vim.api.nvim_set_hl(0, "IncSearch", { bg = "#e95d5d", fg = "#131a24", bold = true })
vim.api.nvim_set_hl(0, "MacroRecording", { bg = "#dbc874", fg = "#131a24", bold = true })


-- GitSings hilights
vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#428bc0" })
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#7aa4a1" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fda47f" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#e85c51" })
vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { fg = "#e85c51" })

vim.api.nvim_set_hl(0, 'Cursor', { bg = "#d7d8dc", reverse = true, bold = true })

-- nightfox
M.float_color = "#202d3f"
M.float_border_bg_color = "#1d293a"
M.float_border_fg_color = "#578ea5"
M.line_hilight = "#0a161e"

-- terafox
-- M.float_color = "#112631"
-- M.line_hilight = "#07161a"


-- Statusline and Tabline
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = M.line_hilight, fg = "#aeafb0", blend = 0 })
vim.api.nvim_set_hl(0, "StatusLine", { bg = M.line_hilight, fg = "#71839b", blend = 0 })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = M.line_hilight })


if vim.g.neovide then
    -- M.line_hilight = "#030a0c"
    M.line_hilight = "#011425"
end

M.neovide_float_winblend = 40
M.float_winblend = 15

vim.api.nvim_set_hl(0, "MarkStatusLine", { bg = "#354965", fg = "#aeafb0", bold = true })
vim.api.nvim_set_hl(0, "FloatTitle", { bg = M.float_color, blend = M.float_winblend })

vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true, }) -- hilight for selected itme in cmp menu
vim.api.nvim_set_hl(0, "CmpComplitionMenu", { bg = M.float_color, })                        -- hilight for cmp menu

if vim.g.neovide then
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = M.float_color, blend = M.neovide_float_winblend }) -- hilight for cmp menu
    vim.api.nvim_set_hl(0, "FloatBorder",
        { fg = M.float_border_fg_color, bg = M.float_border_bg_color, blend = M.neovide_float_winblend })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = M.float_color, blend = M.neovide_float_winblend }) -- hilight for cmp menu
else
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = M.float_color, blend = M.float_winblend })               -- hilight for cmp menu
    vim.api.nvim_set_hl(0, "FloatBorder",
        { fg = M.float_border_fg_color, bg = M.float_border_bg_color, blend = M.float_winblend })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = M.float_color, blend = M.float_winblend }) -- hilight for cmp menu
end

vim.api.nvim_set_hl(0, "YaziFloat", { link = "NormalFloat" })

-- cmp kind hl
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "#cf3930", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { bg = "#dbc874", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { bg = "#ff5c52", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { bg = "#59b9ff", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { bg = "#76abdc", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "#afafff", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindField", { bg = "#aad5d6", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { bg = "#7ad5d6", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { bg = "#689dc4", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "#dfdfe0", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { bg = "#cfa333", fg = "#131a24" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { bg = "#81b29a", fg = "#131a24" })

-- cmp menu hl
vim.api.nvim_set_hl(0, "CmpItemMenuKeyword", { fg = "#cf3930", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuClass", { fg = "#dbc074", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuStruct", { fg = "#ff5c52", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuSnippet", { fg = "#59b9ff", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuMethod", { fg = "#76abdc", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuFunction", { fg = "#afafff", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuField", { fg = "#aad5d6", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuEnum", { fg = "#7ad5d6", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuProperty", { fg = "#689dc4", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuVariable", { fg = "#dfdfe0", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuValue", { fg = "#cfa333", italic = true })
vim.api.nvim_set_hl(0, "CmpItemMenuText", { fg = "#81b29a", italic = true })

-- Cursorword
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#30425b", underline = false, bold = false })
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})

-- visual
vim.api.nvim_set_hl(0, "Visual", { bg = "#3a4f6d", bold = true, })

return M
