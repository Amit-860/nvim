return {
    "stevearc/oil.nvim",
    opts = {
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        keymaps = {
            ["g?"] = { "actions.show_help", mode = "n" },
            ["<CR>"] = { "actions.select", mode = "n" },
            ["<BS>"] = { "actions.parent", mode = "n" },
            ["<C-v>"] = { "actions.select", opts = { vertical = true } },
            -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
            -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
            ["<C-p>"] = "actions.preview",
            ["<C-q>"] = { "actions.close", mode = "n" },
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
            max_width = math.floor(vim.o.columns * 0.85),
            max_height = math.floor(vim.o.lines * 0.85),
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
        vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" }),
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        -- { "echasnovski/mini.icons", opts = {}}
    },
    config = function(_, opts)
        local oil = require("oil")
        oil.setup(opts)

        local oil_aug = vim.api.nvim_create_augroup("oil_aug", { clear = true })
        vim.api.nvim_create_autocmd({ "FileType" }, {
            pattern = "oil",
            group = oil_aug,
            callback = function(event)
                vim.keymap.set({ "n", "i" }, "<C-s>", function()
                    oil.save()
                end, { buffer = event.buf })
            end,
        })
    end,
}
