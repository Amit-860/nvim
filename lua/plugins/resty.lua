return {
    {
        "lima1909/resty.nvim",
        ft = "http",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {},
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("kulala_au", { clear = true }),
                pattern = "http",
                callback = function(event)
                    vim.keymap.set("n", "<leader>ra", ":Resty run<CR>", { desc = "[R]esty [R]un", buffer = event.buff })
                    vim.keymap.set(
                        "n",
                        "<leader>rl",
                        ":Resty last<CR>",
                        { desc = "[R]esty run [L]ast", buffer = event.buff }
                    )
                end,
            })
        end,
    },
}
