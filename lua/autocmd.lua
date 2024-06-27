local buf_large_aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    callback = function()
        local max_filesize = 1024 * 1024 * 5
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        if ok and stats and (stats.size > max_filesize) then
            vim.b.large_buf = true
            vim.cmd("syntax off")
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
            vim.b.miniindentscope_disable = true
            vim.cmd("TSBufDisable highlight")
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
        vim.api.nvim_set_hl(0, "TabLineFill", { bg = nil })
        -- end
    end,
    group = starter_aug,
    pattern = "MiniStarterOpened",
})

local hilight = require('colors').line_hilight
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.g.starter_opened = false
        vim.b.ministatusline_disable = false
        vim.b.minitabline_disable = false
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = hilight, fg = "#aeafb0", blend = 0 })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = hilight, fg = "#71839b", blend = 0 })
        vim.api.nvim_set_hl(0, "TabLineFill", { bg = hilight })
    end,
    group = starter_aug,
})

vim.g.miniInitialized = false
local mini_lazyloading_aug = vim.api.nvim_create_augroup("lazy", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    callback = function()
        if not vim.g.miniInitialized then
            require('pluginSetups.miniConfig')
            require('pluginSetups.miniStatuslineConfig')
            require('pluginSetups.miniTablineConfig')
            vim.g.miniInitialized = true
        end
    end,
    group = mini_lazyloading_aug,
})

local disable_statusline_aug = vim.api.nvim_create_augroup("disable_statusline", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        if not vim.g.miniInitialized then
            require('pluginSetups.miniConfig')
            require('pluginSetups.miniStatuslineConfig')
            require('pluginSetups.miniTablineConfig')
            vim.g.miniInitialized = true
        end
    end,
    group = mini_lazyloading_aug,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
    pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("json_conceal", { clear = true }),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})
