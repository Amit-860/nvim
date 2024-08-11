return {
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = { "Neorg" },
    dependencies = {
        { "nvim-neorg/lua-utils.nvim", event = "VeryLazy", },
        { "nvim-lua/plenary.nvim" },
        { "nvim-neorg/neorg-telescope" }
    },
    version = "*",
    opts = function()
        -- NOTE : config opts for neorg
        local neorg_opts = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        -- icon_preset = "diamond",
                        icons = { code_block = { spell_check = true } },
                    },
                },
                ["core.ui"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = { notes = vim.fn.expand("D:/notes"), },
                        default_workspace = "notes",
                    },
                },
                ["core.dirman.utils"] = {},
                ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Neorg]" } },
                ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
                ["core.integrations.nvim-cmp"] = {},
                ["core.integrations.treesitter"] = {},
                ["core.qol.toc"] = {},
                ["core.qol.todo_items"] = {},
                ["core.looking-glass"] = {},
                ["core.export"] = {},
                ["core.export.markdown"] = { config = { extensions = "all" } },
                ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
                ["core.summary"] = {},
                ["core.tangle"] = { config = { report_on_empty = false } },
                ["core.ui.calendar"] = {},
                ["core.journal"] = {
                    config = {
                        strategy = "nested",
                    },
                },
                ["core.keybinds"] = {
                    -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
                    config = {
                        default_keybinds = true,
                        -- neorg_leader = "<F13>",
                        hook = function(keybind)
                            keybind.map("norg", "n", "<F13>i", "<nop>", { desc = "Norg insert" })
                            keybind.map("norg", "n", "<F13>m", "<nop>", { desc = "Norg mode" })
                            keybind.map("norg", "n", "<F13>n", "<nop>", { desc = "Norg new note" })
                            keybind.map("norg", "n", "<F13>t", "<nop>", { desc = "Norg mark" })
                            keybind.map("norg", "n", "<F13>l", "<nop>", { desc = "Norg list" })
                        end
                    },
                },
                ["core.syntax"] = {},
                ["core.neorgcmd"] = {},
                ["core.queries.native"] = {}
            },
        }

        return neorg_opts
    end,
    config = function(_, opts)
        require('neorg').setup(opts)
    end
}
