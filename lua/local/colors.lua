M = {}

-- nightfox
-- M.float_color = "#202d3f"
M.float_border_bg_color = "#1d293a"
M.float_border_fg_color = "#578ea5"
-- M.line_hilight = "#0a161e"

-- terafox
M.float_color = "#112631"
-- M.float_color = "#061621"
M.float_border_bg_color = "#112631"
M.line_hilight = "#07161a"

if vim.g.neovide then
    -- M.line_hilight = "#030a0c"
    M.line_hilight = "#011425"
end

M.neovide_float_winblend = 30
M.float_winblend = 20

-- GitSings highlights
vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#095611" })
-- vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#7aa4a1" })
-- vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fda47f" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#e85c51" })
vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { fg = "#e85c51" })

--Find and replace
vim.api.nvim_set_hl(0, "FindAndReplace", { bg = "#ff6f65", fg = "#131a24", bold = true })

-- macro
vim.api.nvim_set_hl(0, "MacroRecording", { bg = "#dbc874", fg = "#131a24", bold = true })

-- Grappel mark statusline
vim.api.nvim_set_hl(0, "MarkStatusLine", { bg = "#354965", fg = "#aeafb0", bold = true })

-- cmp
vim.api.nvim_set_hl(0, "CmpSelectedItem", { link = "Visual" }) -- highlights for selected item in cmp menu

-- cmp kind hl
vim.api.nvim_set_hl(0, "ItemKindKeyword", { bg = "#cf3930", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindClass", { bg = "#dbc874", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindStruct", { bg = "#ff5c52", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindSnippet", { bg = "#59b9ff", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindMethod", { bg = "#76abdc", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindFunction", { bg = "#afafff", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindField", { bg = "#aad5d6", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindEnum", { bg = "#7ad5d6", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindProperty", { bg = "#689dc4", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindVariable", { bg = "#dfdfe0", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindValue", { bg = "#cfa333", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindText", { bg = "#81b29a", fg = "#131a24" })
vim.api.nvim_set_hl(0, "ItemKindUnknown", { bg = "#fda47f", fg = "#131a24" })

vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#898e98" })

-- cmp menu hl
vim.api.nvim_set_hl(0, "ItemMenuKeyword", { fg = "#cf3930", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuClass", { fg = "#dbc074", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuStruct", { fg = "#ff5c52", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuSnippet", { fg = "#59b9ff", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuMethod", { fg = "#76abdc", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuFunction", { fg = "#afafff", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuField", { fg = "#aad5d6", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuEnum", { fg = "#7ad5d6", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuProperty", { fg = "#689dc4", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuVariable", { fg = "#dfdfe0", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuValue", { fg = "#cfa333", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuText", { fg = "#81b29a", italic = true })
vim.api.nvim_set_hl(0, "ItemMenuUnknown", { fg = "#fda47f", italic = true })

-- INFO: theme specific settings
if vim.g.neovide or vim.g.transparent then
    -- NOTE: only neovide
    if vim.g.neovide and vim.g.neovide_custom_color then
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = M.float_color, blend = M.neovide_float_winblend }) -- highlights for cmp menu
        vim.api.nvim_set_hl(
            0,
            "FloatBorder",
            { fg = M.float_border_fg_color, bg = M.float_border_bg_color, blend = M.neovide_float_winblend }
        )
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = M.float_color, blend = M.neovide_float_winblend }) -- highlights for cmp menu
        -- vim.api.nvim_set_hl(0, "SnacksNormal", { link = "NormalFloat" }) -- highlights for selected item in cmp menu
        -- vim.api.nvim_set_hl(0, "SnacksNormalNC", { link = "NormalFloat" }) -- highlights for selected item in cmp menu
        -- vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", { bg = "#061621", blend = 75 }) -- highlights for selected item in cmp menu
        vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", { bg = M.float_color, blend = 70 }) -- highlights for selected item in cmp menu
        vim.api.nvim_set_hl(0, "SnacksScratchTitle", { link = "NormalFloat" }) -- highlights for selected item in cmp menu
        vim.api.nvim_set_hl(0, "SnacksScratchFooter", { link = "NormalFloat" }) -- highlights for selected item in cmp menu
    end

    -- NOTE: only transparency
    if vim.g.transparent then
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = M.float_color, blend = M.float_winblend }) -- highlights for cmp menu
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = M.float_color, blend = M.float_winblend }) -- highlights for cmp menu
        vim.api.nvim_set_hl(
            0,
            "FloatBorder",
            { fg = M.float_border_fg_color, bg = M.float_border_bg_color, blend = M.float_winblend }
        )
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = M.float_color, blend = M.float_winblend })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = nil, blend = M.float_winblend })
        vim.api.nvim_set_hl(0, "FzfLuaNormal", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "SnacksDashboardTerminal", { bg = "#111c25", blend = 10 })
        vim.api.nvim_set_hl(0, "SnacksNotifierHistory", { link = "NormalFloat" })
    end

    -- cmp menu
    vim.api.nvim_set_hl(0, "CmpComplitionMenu", { bg = M.float_color }) -- highlights for cmp menu
    vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true }) -- highlights for selected item in cmp menu

    -- vim.api.nvim_set_hl(0, "FloatTitle", { bg = M.float_color, blend = M.float_winblend })

    vim.api.nvim_set_hl(0, "IncSearch", { bg = "#ff6f65", fg = "#131a24", bold = true })

    -- visual
    -- vim.api.nvim_set_hl(0, "Visual", { bg = "#3a4f6d", bold = true, })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#194c65", bold = true })

    -- treesitter context
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#001925", fg = "#84c4c9", bold = false })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { bg = "#001925", fg = "#b8514b", bold = true })

    vim.api.nvim_set_hl(0, "YaziFloat", { link = "NormalFloat" })
end

return M
