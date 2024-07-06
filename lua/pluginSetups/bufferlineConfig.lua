local bufferline = require('bufferline')
local opts = {
    options = {
        -- style_preset = bufferline.style_preset.no_italic,
        separator_style = "slope",
        max_name_length = 24,
        always_show_bufferline = false,
        offsets = {
            {
                filetype = "undotree",
                text = "Undotree",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "neotree",
                text = "Explorer",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "DiffviewFiles",
                text = "Diff View",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "flutterToolsOutline",
                text = "Flutter Outline",
                highlight = "PanelHeading",
            },
            {
                filetype = "lazy",
                text = "Lazy",
                highlight = "PanelHeading",
                padding = 1,
            },
        },
    }
}

vim.cmd([[hi BufferLinePickSelected cterm=bold,italic gui=bold,italic guifg=#e85c51 guibg=#002f44]])
vim.cmd([[hi BufferLinePickVisible cterm=bold,italic gui=bold,italic guifg=#e85c51 guibg=#002b3e]])
vim.cmd([[hi BufferLineOffsetSeparator guifg=#0f1c1e guibg=#001925]])
vim.cmd([[hi BufferLineWarningDiagnosticVisible guifg=#515f68 guibg=#002b3e]])
vim.cmd([[hi BufferLineInfo guifg=#6d7f8b guibg=#002333 guisp=#5a93aa]])
vim.cmd([[hi BufferLinePick cterm=bold,italic gui=bold,italic guifg=#e85c51 guibg=#002333]])
vim.cmd([[hi BufferLineGroupSeparator guifg=#6d7f8b guibg=#001925]])
vim.cmd([[hi BufferLineTab guifg=#6d7f8b guibg=#002333]])
vim.cmd([[hi BufferLineWarning guifg=#6d7f8b guibg=#002333 guisp=#fda47f]])
vim.cmd([[hi BufferLineNumbersSelected cterm=bold,italic gui=bold,italic guifg=#e6eaea guibg=#002f44]])
vim.cmd([[hi BufferLineSeparator guifg=#001925 guibg=#002333]])
vim.cmd([[hi BufferLineBackground guifg=#6d7f8b guibg=#002333]])
vim.cmd(
    [[hi BufferLineHintDiagnosticSelected cterm=bold,italic gui=bold,italic guifg=#5b7b78 guibg=#002f44 guisp=#5b7b78]])
vim.cmd([[hi BufferLineFill guifg=#6d7f8b guibg=#001925]])
vim.cmd([[hi BufferLineHint guifg=#6d7f8b guibg=#002333 guisp=#7aa4a1]])
vim.cmd([[hi BufferLineDiagnostic guifg=#515f68 guibg=#002333]])
vim.cmd([[hi BufferLineBuffer guifg=#6d7f8b guibg=#002333]])
vim.cmd([[hi BufferLineTruncMarker guifg=#6d7f8b guibg=#001925]])
vim.cmd([[hi BufferLineDuplicate cterm=italic gui=italic guifg=#677884 guibg=#002333]])
vim.cmd([[hi BufferLineGroupLabel guifg=#001925 guibg=#6d7f8b]])
vim.cmd([[hi BufferLineTabSelected guifg=#587b7b guibg=#002f44]])
vim.cmd([[hi BufferLineTabClose guifg=#6d7f8b guibg=#002333]])
vim.cmd([[hi BufferLineCloseButton guifg=#6d7f8b guibg=#002333]])
vim.cmd([[hi BufferLineCloseButtonVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineCloseButtonSelected guifg=#e6eaea guibg=#002f44]])
vim.cmd([[hi BufferLineBufferVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineBufferSelected cterm=bold,italic gui=bold,italic guifg=#e6eaea guibg=#002f44]])
vim.cmd([[hi BufferLineNumbers guifg=#6d7f8b guibg=#002333]])
vim.cmd([[hi BufferLineNumbersVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineDiagnosticVisible guifg=#515f68 guibg=#002b3e]])
vim.cmd([[hi BufferLineDiagnosticSelected cterm=bold,italic gui=bold,italic guifg=#acafaf guibg=#002f44]])
vim.cmd([[hi BufferLineHintVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineHintSelected cterm=bold,italic gui=bold,italic guifg=#7aa4a1 guibg=#002f44 guisp=#7aa4a1]])
vim.cmd([[hi BufferLineHintDiagnostic guifg=#515f68 guibg=#002333 guisp=#5b7b78]])
vim.cmd([[hi BufferLineHintDiagnosticVisible guifg=#515f68 guibg=#002b3e]])
vim.cmd([[hi BufferLineModified guifg=#7aa4a1 guibg=#002333]])
vim.cmd([[hi BufferLineInfoVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineInfoSelected cterm=bold,italic gui=bold,italic guifg=#5a93aa guibg=#002f44 guisp=#5a93aa]])
vim.cmd([[hi BufferLineInfoDiagnostic guifg=#515f68 guibg=#002333 guisp=#436e7f]])
vim.cmd([[hi BufferLineInfoDiagnosticVisible guifg=#515f68 guibg=#002b3e]])
vim.cmd(
    [[hi BufferLineInfoDiagnosticSelected cterm=bold,italic gui=bold,italic guifg=#436e7f guibg=#002f44 guisp=#436e7f]])
vim.cmd([[hi BufferLineWarningVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineWarningSelected cterm=bold,italic gui=bold,italic guifg=#fda47f guibg=#002f44 guisp=#fda47f]])
vim.cmd([[hi BufferLineWarningDiagnostic guifg=#515f68 guibg=#002333 guisp=#bd7b5f]])
vim.cmd([[hi BufferLineError guifg=#6d7f8b guibg=#002333 guisp=#e85c51]])
vim.cmd(
    [[hi BufferLineWarningDiagnosticSelected cterm=bold,italic gui=bold,italic guifg=#bd7b5f guibg=#002f44 guisp=#bd7b5f]])
vim.cmd([[hi BufferLineErrorVisible guifg=#6d7f8b guibg=#002b3e]])
vim.cmd([[hi BufferLineErrorSelected cterm=bold,italic gui=bold,italic guifg=#e85c51 guibg=#002f44 guisp=#e85c51]])
vim.cmd([[hi BufferLineErrorDiagnostic guifg=#515f68 guibg=#002333 guisp=#ae453c]])
vim.cmd([[hi BufferLineErrorDiagnosticVisible guifg=#515f68 guibg=#002b3e]])
vim.cmd(
    [[hi BufferLineErrorDiagnosticSelected cterm=bold,italic gui=bold,italic guifg=#ae453c guibg=#002f44 guisp=#ae453c]])
vim.cmd([[hi BufferLineModifiedVisible guifg=#7aa4a1 guibg=#002b3e]])
vim.cmd([[hi BufferLineModifiedSelected guifg=#7aa4a1 guibg=#002f44]])
vim.cmd([[hi BufferLineDuplicateSelected cterm=italic gui=italic guifg=#677884 guibg=#002f44]])
vim.cmd([[hi BufferLineDuplicateVisible cterm=italic gui=italic guifg=#677884 guibg=#002b3e]])
vim.cmd([[hi BufferLineSeparatorSelected guifg=#001925 guibg=#002f44]])
vim.cmd([[hi BufferLineSeparatorVisible guifg=#001925 guibg=#002b3e]])
vim.cmd([[hi BufferLineTabSeparator guifg=#001925 guibg=#002333]])
vim.cmd([[hi BufferLineTabSeparatorSelected guifg=#001925 guibg=#002f44]])
vim.cmd([[hi BufferLineIndicatorSelected guifg=#587b7b guibg=#002f44]])
vim.cmd([[hi BufferLineIndicatorVisible guifg=#002b3e guibg=#002b3e]])
vim.cmd([[hi BufferLineDevIconLua guifg=#51a0cf guibg=#002333]])
vim.cmd([[hi BufferLineDevIconLuaSelected guifg=#51a0cf guibg=#002f44]])
vim.cmd([[hi BufferLineDevIconLuaInactive guifg=#51a0cf guibg=#002b3e]])

bufferline.setup(opts)
