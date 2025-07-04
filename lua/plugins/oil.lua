return {
    "stevearc/oil.nvim",
    cond = not vim.g.vscode,
    cmd = { "Oil" },
    opts = {
        columns = { "icon" },
        keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<CR>"] = { "actions.select", mode = "n" },
            ["<BS>"] = { "actions.parent", mode = "n" },
            ["<C-v>"] = { "actions.select", opts = { vertical = true } },
            -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
            -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
            ["<C-p>"] = "actions.preview",
            ["<C-r>"] = "actions.refresh",
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["`"] = { "actions.cd", mode = "n" },
            ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["gs"] = { "actions.change_sort", mode = "n" },
            ["gx"] = "actions.open_external",
            ["g."] = { "actions.toggle_hidden", mode = "n" },
            ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = false,
        -- Window-local options to use for oil buffers
        win_options = {
            wrap = false,
            signcolumn = "no",
            cursorcolumn = false,
            foldcolumn = "0",
            spell = false,
            list = false,
            conceallevel = 3,
            concealcursor = "nvic",
        },
        float = {
            -- Padding around the floating window
            padding = 2,
            max_width = math.floor(vim.o.columns * 0.8),
            max_height = math.floor(vim.o.lines * 0.8),
            border = "single",
            win_options = {
                winblend = 10,
            },
            -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
            get_win_title = nil,
            -- preview_split: Split direction: "auto", "left", "right", "above", "below".
            preview_split = "auto",
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            override = function(conf)
                return conf
            end,
        },
        keymaps_help = {
            border = "single",
        },
    },
    keymap = {
        vim.keymap.set("n", "<F13>o", "<CMD>Oil --float<CR>", { desc = "Oil Float" }),
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
        local oil = require("oil")
        local detail = false
        opts.keymaps = vim.tbl_deep_extend("force", opts.keymaps, {
            ["gd"] = {
                desc = "Toggle file detail view",
                callback = function()
                    detail = not detail
                    if detail then
                        require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                    else
                        require("oil").set_columns({ "icon" })
                    end
                end,
            },
            ["<C-s>"] = {
                desc = "Save Change",
                callback = function()
                    oil.save()
                end,
            },
            ["<C-q>"] = {
                desc = "Quit Oil",
                mode = "n",
                callback = function()
                    oil.close()
                end,
            },
            ["<leader>x"] = {
                desc = "Quit Oil",
                mode = "n",
                callback = function()
                    oil.close()
                end,
            },
        })
        oil.setup(opts)
    end,
}
