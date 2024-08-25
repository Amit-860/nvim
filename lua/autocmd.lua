local augroup = vim.api.nvim_create_augroup

-- preventing neovim from commenting new line before/after commented line
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell", { clear = true }),
    pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown", "norg" },
    callback = function()
        vim.opt_local.textwidth = 120
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

if vim.g.transparent and not vim.g.neovide then
    vim.api.nvim_create_autocmd({ "UIEnter" }, {
        group = vim.api.nvim_create_augroup("transparent", { clear = true }),
        callback = function(event)
            -- transparent
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
        end,
    })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = vim.api.nvim_create_augroup("Applying colorscheme", { clear = true }),
    callback = function(event)
        if vim.g.neovide then
            vim.cmd("colorscheme " .. vim.g.neovide_colorscheme)
        else
            vim.cmd("colorscheme " .. vim.g.colorscheme)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("yank_hilight", { clear = true }),
    callback = function(event)
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = vim.o.timeoutlen })
    end,
})
