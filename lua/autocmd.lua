local augroup = vim.api.nvim_create_augroup
local buf_large_aug = augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    callback = function()
        local max_filesize = 1024 * 1024 * 5
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        if ok and stats and (stats.size > max_filesize) then
            vim.b.large_buf = true
            -- vim.cmd("syntax off")
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

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell", { clear = true }),
    pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("json_conceal", { clear = true }),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc", { clear = true }),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("close_with_q", { clear = true }),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "notify",
        "qf",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
        "dbout",
        "gitsigns.blame",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
