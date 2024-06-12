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


local starter_aug = vim.api.nvim_create_augroup("starter", { clear = true })
vim.api.nvim_create_autocmd("User", {
    callback = function()
        -- local data = {
        --     buf = vim.fn.expand("<abuf>"),
        --     file = vim.fn.expand("<afile>"),
        --     match = vim.fn.expand("<amatch>")
        -- }
        -- -- print(vim.inspect(data))
        -- local buf_name = string.lower(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        -- if buf_name:find('start') then
        vim.b.ministatusline_disable = true
        vim.b.minitabline_disable = true
        vim.g.starter_opened = true
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = nil })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = nil })
        -- end
    end,
    group = starter_aug,
    pattern = "MiniStarterOpened",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.g.starter_opened = false
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#131a24", fg = "#aeafb0" })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#131a24", fg = "#71839b" })
    end,
    group = starter_aug,
    pattern = "*"
})
