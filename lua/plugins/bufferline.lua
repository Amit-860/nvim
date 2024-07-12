return {
    'akinsho/bufferline.nvim',
    event = { "UIEnter" },
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = function()
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

        return opts
    end,
    config = function(_, opts)
        local bufferline = require('bufferline')

        if vim.g.neovide then
            opts.options.separator_style = "thick"
            --     opts.options.style_preset = bufferline.style_preset.no_italic
            vim.api.nvim_set_hl(0, "BufferLineFill", { fg = "#001925", bg = "#001925" })
        end

        bufferline.setup(opts)

        -- Fix bufferline when restoring a session
        vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
            callback = function()
                vim.schedule(function()
                    pcall(nvim_bufferline)
                end)
            end,
        })
    end
}
