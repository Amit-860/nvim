return {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    cond = not vim.g.vscode,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse" },
    opts = function()
        local nvimtree_opts = {
            hijack_cursor = true,
            sync_root_with_cwd = true,
            view = {
                adaptive_size = true,
                side = "right",
                width = "22%",
                float = {
                    enable = true,
                    quit_on_focus_loss = true,
                    open_win_config = {
                        relative = "editor",
                        border = "single",
                        height = vim.o.lines - 2,
                        width = math.floor(vim.o.columns * 0.5),
                        row = 1,
                        -- col = vim.o.columns,
                        col = 0,
                    },
                },
            },
            renderer = {
                full_name = true,
                group_empty = true,
                special_files = {},
                symlink_destination = true,
                indent_markers = {
                    enable = true,
                },
                icons = {
                    git_placement = "after",
                    modified_placement = "after",
                    diagnostics_placement = "signcolumn",
                    padding = " ",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                        diagnostics = false,
                    },
                },
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = { "help", "TelescopePrompt", "sancks_dashboard" },
            },
            diagnostics = {
                enable = false,
                show_on_dirs = true,
            },
            filters = {
                custom = {
                    "^.git$",
                },
            },
            actions = {
                change_dir = {
                    enable = true,
                    restrict_above_cwd = true,
                },
                open_file = {
                    resize_window = true,
                    window_picker = {
                        chars = "aoeui",
                    },
                },
                remove_file = {
                    close_window = true,
                },
            },
            log = {
                enable = false,
                truncate = true,
                types = {
                    all = false,
                    config = false,
                    copy_paste = false,
                    diagnostics = false,
                    git = false,
                    profile = false,
                    watcher = false,
                },
            },
        }
        return nvimtree_opts
    end,
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { link = "Normal" })
    end,
}
