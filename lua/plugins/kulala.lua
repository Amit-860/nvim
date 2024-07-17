return {
    'mistweaverco/kulala.nvim',
    ft = 'http',
    opts = {
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        -- enable/disable debug mode
        debug = false,
        -- default formatters for different content types
        formatters = {
            json = { "jq", "." },
            xml = {
                "tidy",
                "-i",
                "-q",
                "--tidy-mark", "no",
                "--show-body-only", "auto",
                "--show-errors", "0",
                "--show-warnings", "0",
                "-",
                "."
            },
            html = {
                "tidy",
                "-i",
                "-q",
                "--tidy-mark", "no",
                "--show-body-only", "auto",
                "--show-errors", "0",
                "--show-warnings", "0",
                "-",
                "."
            },
        },
        -- default icons
        icons = {
            inlay = {
                loading = "⏳",
                done = "✅ "
            },
            lualine = "🐼",
        },
        -- additional cURL options
        -- e.g. { "--insecure", "-A", "Mozilla/5.0" }
        additional_curl_options = {},
    },
    config = function(_, opts)
        -- Setup is required, even if you don't pass any options
        require('kulala').setup(opts)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("kulala_au", { clear = true }),
            callback = function(event)
                vim.keymap.set('n', "<leader>lr", function() require('kulala').run() end,
                    { noremap = true, silent = true, desc = 'Kulala Run', buffer = event.buff })
                vim.keymap.set('n', "<leader>lv", function() require('kulala').toggle_view() end,
                    { noremap = true, silent = true, desc = 'Kulala toggle view', buffer = event.buff })
                vim.keymap.set('n', "]r", function() require('kulala').jump_next() end,
                    { noremap = true, silent = true, desc = 'Jump next req', buffer = event.buff })
                vim.keymap.set('n', "[r", function() require('kulala').jump_prev() end,
                    { noremap = true, silent = true, desc = 'Jump prev req', buffer = event.buff })
                vim.keymap.set('n', "<leader>le", function() require('kulala').set_selected_env() end,
                    { noremap = true, silent = true, desc = 'Kulala envs', buffer = event.buff })
            end,
        })
    end
}
