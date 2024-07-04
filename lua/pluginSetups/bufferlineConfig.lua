local bufferline = require('bufferline')

bufferline.setup {
    options = {
        style_preset = bufferline.style_preset.no_italic,
        separator_style = "slope",
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
