local buf_large_aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    callback = function()
        local max_filesize = 1024 * 1024 * 10
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        if ok and stats and (stats.size > max_filesize) then
            vim.b.large_buf = true
            vim.cmd("syntax off")
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
            vim.b.miniindentscope_disable = true
        else
            vim.b.large_buf = false
        end
    end,
    group = buf_large_aug,
    pattern = "*",
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    callback = function()
        if vim.b.large_buf then
            vim.cmd([[TSContextDisable]])
        else
            vim.cmd([[TSContextEnable]])
        end
    end,
    group = buf_large_aug,
    pattern = "*",
})
