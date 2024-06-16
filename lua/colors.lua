-- vim.api.nvim_set_hl(0, "MatchParen", { bg = nil, fg = "#fffd00", underline = true, bold = true })
-- vim.api.nvim_set_hl(0, "MatchParen", { bg = "#4d5969", fg = "#ffffff", underline = false, bold = true })

vim.api.nvim_set_hl(0, "MarkStatusLine", { bg = "#354965", fg = "#aeafb0", bold = true })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#202d3f", blend = 15 })
vim.api.nvim_set_hl(0, "FloatTitle", { bg = "#202d3f", blend = 15 })

-- vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true, reverse = true })
vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true, }) -- hilight for selected itme in cmp menu
vim.api.nvim_set_hl(0, "CmpComplitionMenu", { bg = "#202d3f", })                            -- hilight for cmp menu

if vim.g.neovide then
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#202d3f", blend = 75 })       -- hilight for cmp menu
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#202d3f", blend = 75 }) -- hilight for cmp menu
else
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#202d3f", blend = 15 })       -- hilight for cmp menu
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#202d3f", blend = 15 }) -- hilight for cmp menu
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
