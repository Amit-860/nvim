return {
    'akinsho/bufferline.nvim',
    event = { "UIEnter" },
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
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

        if vim.g.neovide then
            opts.options.separator_style = "thick"
            --     opts.options.style_preset = bufferline.style_preset.no_italic
            vim.api.nvim_set_hl(0, "BufferLineFill", { fg = "#001925", bg = "#001925" })
        end

        bufferline.setup(opts)
    end
}
