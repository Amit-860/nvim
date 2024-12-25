return {
    {
        "Bekaboo/dropbar.nvim",
        -- optional, but required for fuzzy finder support
        dependencies = {
            -- "nvim-telescope/telescope-fzf-native.nvim",
            -- build = "make",
        },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local dropbar_api = require("dropbar.api")
            vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Winbar Symbol" })
            vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
            vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

            local dropbar = require("dropbar")
            dropbar.setup({
                icons = {
                    ui = {
                        bar = {
                            separator = "  ",
                            extends = "…",
                        },
                        menu = {
                            separator = " ",
                            indicator = " ",
                        },
                    },
                },
                menu = {
                    preview = false,
                    win_configs = {
                        border = vim.g.win_border,
                    },
                    keymaps = {
                        ["i"] = function()
                            local menu = require("dropbar.utils").menu.get_current()
                            if not menu then
                                return
                            end
                        end,
                    },
                },
                sources = {
                    path = {
                        preview = function(_)
                            return false
                        end,
                    },
                },
            })

            vim.api.nvim_set_hl(0, "DropBarMenuHoverEntry", { link = "DropBarMenuSbar" }) -- highlights for selected item in cmp menu
            vim.api.nvim_set_hl(0, "DropBarMenuHoverIcon", { link = "DropBarMenuSbar" }) -- highlights for selected item in cmp menu
            vim.api.nvim_set_hl(0, "DropBarMenuHoverSymbol", { link = "DropBarMenuSbar" }) -- highlights for selected item in cmp menu
            vim.api.nvim_set_hl(0, "DropBarMenuThumb", { link = "DropBarMenuSbar" }) -- highlights for selected item in cmp menu
            vim.api.nvim_set_hl(0, "DropBarMenuCurrentContext", { link = "DropBarMenuSbar" }) -- highlights for selected item in cmp menu
        end,
    },
}
