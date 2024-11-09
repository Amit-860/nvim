vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("Resty_au", { clear = true }),
    pattern = "http",
    callback = function(event)
        vim.keymap.set("n", "<leader>ra", ":Resty run<CR>", { desc = "[R]esty [R]un", buffer = event.buff })
        vim.keymap.set("n", "<leader>rl", ":Resty last<CR>", { desc = "[R]esty run [L]ast", buffer = event.buff })
    end,
})
return {
    {
        "lima1909/resty.nvim",
        cond = not vim.g.vscode,
        dependencies = { "nvim-lua/plenary.nvim" },
        -- ft = "http",
        cmd = { "Resty" },
    },
}
