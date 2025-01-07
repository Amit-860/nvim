return {
    -- {
    --     "zongben/navimark.nvim",
    --     cond = not vim.g.vscode,
    --     dependencies = {
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-lua/plenary.nvim",
    --     },
    --     keys = {
    --         { "<F13>m", desc = "Global Bookmark" },
    --         { "<F13>mt", desc = "toggle" },
    --         { "<F13>ma", desc = "add" },
    --         { "<F13>md", desc = "delete" },
    --         { "<F13>mn", desc = "next" },
    --         { "<F13>mp", desc = "prev" },
    --         { "<F13>mm", desc = "list" },
    --     },
    --     config = function()
    --         require("navimark").setup({
    --             keymap = {
    --                 base = {
    --                     mark_toggle = "<F13>mt",
    --                     mark_add = "<F13>ma",
    --                     mark_remove = "<F13>md",
    --                     goto_next_mark = "<F13>mn",
    --                     goto_prev_mark = "<F13>mp",
    --                     open_mark_picker = "<F13>mm",
    --                 },
    --                 telescope = {
    --                     n = {
    --                         delete_mark = "d",
    --                         clear_marks = "c",
    --                         new_stack = "n",
    --                         next_stack = "<Tab>",
    --                         prev_stack = "<S-Tab>",
    --                         rename_stack = "r",
    --                         delete_stack = "D",
    --                         open_all_marked_files = "<C-o>", -- open all marked files in current stack
    --                     },
    --                 },
    --             },
    --             sign = {
    --                 text = "󰃃",
    --                 color = "#b4473f",
    --             },
    --             persist = true,
    --         })
    --     end,
    -- },
    {
        "cbochs/grapple.nvim",
        opts = { scope = "git" },
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Grapple",
        keys = {
            { "<leader>ma", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
            { "<leader>mA", "<cmd>Grapple toggle scope=global<cr>", desc = "Grapple toggle global tag" },
            { "<leader>mm", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
            {
                "mm",
                "<cmd>Telescope grapple tags layout_strategy=horizontal layout_config={preview_width=0.5}<cr>",
                desc = "Grapple open tags window",
            },
            { "<leader>mM", "<cmd>Grapple toggle_tags scope=global<cr>", desc = "Grapple open tags window" },
            {
                "mM",
                "<cmd>Telescope grapple tags scope=global layout_strategy=horizontal layout_config={preview_width=0.5}<cr>",
                desc = "Grapple open tags window",
            },
            { "<leader>mn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
            { "<leader>mp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
        },
        config = function(_, opts)
            require("telescope").load_extension("grapple")
            require("grapple").setup(opts)
        end,
    },
}
