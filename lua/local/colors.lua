M = {}

-- vim.api.nvim_set_hl(0, "MatchParen", { bg = nil, fg = "#fffd00", underline = true, bold = true })
-- vim.api.nvim_set_hl(0, "MatchParen", { bg = "222b39", fg = "#ffffff", underline = false, bold = true })

-- nightfox
-- M.float_color = "#202d3f"
M.float_border_bg_color = "#1d293a"
M.float_border_fg_color = "#578ea5"
-- M.line_hilight = "#0a161e"

-- terafox
M.float_color = "#112631"
M.float_border_bg_color = "#112631"
M.line_hilight = "#07161a"

if vim.g.neovide then
	-- M.line_hilight = "#030a0c"
	M.line_hilight = "#011425"
end

M.neovide_float_winblend = 30
M.float_winblend = 20

-- GitSings hilights
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
vim.api.nvim_set_hl(0, "CmpSelectedItem", { link = "Visual" }) -- hilight for selected itme in cmp menu

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
vim.api.nvim_set_hl(0, "CmpItemKindUnknown", { bg = "#fda47f", fg = "#131a24" })

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
vim.api.nvim_set_hl(0, "CmpItemMenuUnknown", { fg = "#fda47f", italic = true })

vim.api.nvim_set_hl(0, "Cursor", { bg = "#002028", fg = "#efefef", bold = true })

-- INFO: theme specific seetings
if vim.g.neovide or vim.g.transparency then
	-- NOTE: only neovide
	if vim.g.neovide then
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = M.float_color, blend = M.neovide_float_winblend }) -- hilight for cmp menu
		vim.api.nvim_set_hl(
			0,
			"FloatBorder",
			{ fg = M.float_border_fg_color, bg = M.float_border_bg_color, blend = M.neovide_float_winblend }
		)
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = M.float_color, blend = M.neovide_float_winblend }) -- hilight for cmp menu
	end

	-- NOTE: only transparency
	if vim.g.transparency then
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = M.float_color, blend = M.float_winblend }) -- hilight for cmp menu
		vim.api.nvim_set_hl(
			0,
			"FloatBorder",
			{ fg = M.float_border_fg_color, bg = M.float_border_bg_color, blend = M.float_winblend }
		)
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = M.float_color, blend = M.float_winblend }) -- hilight for cmp menu
	end

	-- cmp menu
	vim.api.nvim_set_hl(0, "CmpComplitionMenu", { bg = M.float_color }) -- hilight for cmp menu
	vim.api.nvim_set_hl(0, "CmpSelectedItem", { bg = "#00495c", fg = "#dfdfe0", bold = true }) -- hilight for selected itme in cmp menu

	-- vim.api.nvim_set_hl(0, "FloatTitle", { bg = M.float_color, blend = M.float_winblend })

	vim.api.nvim_set_hl(0, "IncSearch", { bg = "#ff6f65", fg = "#131a24", bold = true })

	-- visual
	-- vim.api.nvim_set_hl(0, "Visual", { bg = "#3a4f6d", bold = true, })
	vim.api.nvim_set_hl(0, "Visual", { bg = "#194c65", bold = true })

	-- treesitter context
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#001925", fg = "#84c4c9", bold = false })
	vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { bg = "#001925", fg = "#b8514b", bold = true })

	vim.api.nvim_set_hl(0, "YaziFloat", { link = "NormalFloat" })

	-- Floating windows
end

return M
