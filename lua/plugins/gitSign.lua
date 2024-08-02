return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    cmd = "Gitsigns",
    opts = function()
        local icons = require("icons")
        local git_sign_opts = {
            signs = {
                add = {
                    text = icons.ui.BoldLineLeft,
                },
                change = {
                    text = icons.ui.BoldLineLeft,
                },
                delete = {
                    text = icons.ui.Triangle,
                },
                topdelete = {
                    text = icons.ui.UpperRightTriangel,
                },
                changedelete = {
                    text = icons.ui.Tilde,
                },
                untracked = {
                    -- text = icons.ui.ThinLineLeft,
                    text = icons.ui.BoldLineLeft,
                },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            sign_priority = 6,
            status_formatter = nil, -- Use default
            update_debounce = 200,
            max_file_length = 40000,
            preview_config = {
                -- Options passed to nvim_open_win
                border = "single",
                style = "minimal",
                relative = "cursor",
                row = 1,
                col = 1,
            },
            on_attach = function(bufnr)
                local function map(mode, lhs, rhs, opts)
                    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                end

                -- Navigation
                map("n", "]g", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
                map("n", "[g", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

                -- Actions
                map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
                -- map('n', '<leader>gn', ':LazyGit<CR>', { desc = "Lazygit" })
                map("v", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
                map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
                map("v", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset HUnk" })
                map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage Buffer" })
                map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Stage Hunk" })
                map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset Buffer" })
                map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
                map("n", "<leader>gB", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', { desc = "Blame" })
                map(
                    "n",
                    "<leader>gb",
                    "<cmd>Gitsigns toggle_current_line_blame<CR>",
                    { desc = "Toggle Curr_line Blame" }
                )
                map("n", "<leader>gx", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Toggle Delete" })

                -- Text object
                map("o", "igh", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select inside Git_Hunk" })
                map("x", "igh", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select inside Git_Hunk" })

                -- Diff View
                map("n", "<leader>gdd", "<CMD>DiffviewOpen<CR>", { desc = "Open Diff View" })
                map("n", "<leader>gdc", "<CMD>DiffviewClose<CR>", { desc = "Close Diff View" })
                map(
                    "n",
                    "<leader>gdh",
                    "<CMD>DiffviewFileHistory %<CR>",
                    { desc = "Open File History for Current File" }
                )
                map("n", "<leader>gdH", "<CMD>DiffviewFileHistory<CR>", { desc = "Open File History" })
            end,
        }

        return git_sign_opts
    end,
}
