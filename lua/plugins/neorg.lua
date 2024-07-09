return {
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = { "Neorg" },
    dependencies = {
        {
            -- Install lua from here first before install luarocksj.nvim and neorg
            -- https://github.com/rjpcomputing/luaforwindows
            "vhyrro/luarocks.nvim",
            priority = 1000,
            config = true,
        },
        "nvim-neorg/lua-utils.nvim"
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
                        -- neorg_leader = "<localleader>",
                        hook = function(keybind)
                            keybind.map("norg", "n", "<localleader>i", "<nop>", { desc = "Norg insert" })
                            keybind.map("norg", "n", "<localleader>m", "<nop>", { desc = "Norg mode" })
                            keybind.map("norg", "n", "<localleader>n", "<nop>", { desc = "Norg new note" })
                            keybind.map("norg", "n", "<localleader>t", "<nop>", { desc = "Norg mark" })
                            keybind.map("norg", "n", "<localleader>l", "<nop>", { desc = "Norg list" })
                        end
                    },
                },
                ["core.syntax"] = {},
                ["core.neorgcmd"] = {},
                ["core.queries.native"] = {}
            },
        }

        return neorg_opts
    end
}
