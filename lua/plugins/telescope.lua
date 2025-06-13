return {
    {
        "nvim-telescope/telescope-project.nvim",
        cond = not vim.g.vscode,
        event = "VeryLazy",
    },
    {
        "debugloop/telescope-undo.nvim",
        cond = not vim.g.vscode,
        cmd = { "Telescope undo" },
    },
    {
        "polirritmico/telescope-lazy-plugins.nvim",
        cond = not vim.g.vscode,
        event = "VeryLazy",
    },
    -- {
    --     "nvim-telescope/telescope-frecency.nvim",
    --     cond = not vim.g.vscode,
    --     event = "VeryLazy",
    -- },
    -- {
    --     "nvim-telescope/telescope-live-grep-args.nvim",
    --     cond = not vim.g.vscode,
    --     event = "VeryLazy",
    -- },
    -- {
    --     "nvim-telescope/telescope-fzf-native.nvim",
    --     cond = not vim.g.vscode,
    --     event = "VeryLazy",
    --     -- Manually run below command in windows
    --     -- cd C:/Users/AMIT/AppData/Roaming/nvim-data/lazy/telescope-fzf-native.nvim
    --     -- "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    --     -- then copy all files from .\telescope-fzf-native.nvim\build\Release to .\telescope-fzf-native.nvim\build
    --     -- basically copy all file form ./Release folder to parent ./Build folder
    -- },
    {
        "nvim-telescope/telescope.nvim",
        cond = not vim.g.vscode,
        event = "VeryLazy",
        dependencies = {
            -- "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
        opts = function()
            local icons = require("icons")
            local actions = require("telescope.actions")

            local telescope_opts = {
                ---@usage disable telescope completely [not recommended]
                active = true,
                on_config_done = nil,
                -- theme = "dropdown", ---@type telescope_themes
                file_ignore_patterns = { "%.git/." },
                defaults = {
                    prompt_prefix = icons.ui.Telescope .. " ",
                    selection_caret = icons.ui.RightTriangle .. " ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = nil,
                    layout_strategy = nil,
                    layout_config = {},
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    ---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.move_selection_next,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                            ["<C-j>"] = actions.cycle_history_next,
                            ["<C-k>"] = actions.cycle_history_prev,
                            ["<C-q>"] = function(...)
                                actions.smart_send_to_qflist(...)
                                actions.open_qflist(...)
                            end,
                            ["<CR>"] = actions.select_default,
                        },
                        n = {
                            ["<C-n>"] = actions.move_selection_next,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<C-q>"] = function(...)
                                actions.smart_send_to_qflist(...)
                                actions.open_qflist(...)
                            end,
                            ["q"] = actions.close,
                        },
                    },
                    file_ignore_patterns = { "node_modules", "package-lock.json" },
                    path_display = { tail = 3 },
                    -- - "hidden"          hide file names
                    -- - "tail"            only display the file name, and not the path
                    -- - "absolute"        display absolute paths
                    -- - "smart"           remove as much from the path as possible to only show
                    --                     the difference between the displayed paths.
                    --                     Warning: The nature of the algorithm might have a negative
                    --                     performance impact!
                    -- - "shorten"         only display the first character of each directory in
                    --                     the path
                    -- - "truncate"        truncates the start of the path when the whole path will
                    --                     not fit. To increase the gap between the path and the edge,
                    --                     set truncate to number `truncate = 3`
                    -- - "filename_first"  shows filenames first and then the directories

                    winblend = 0,
                    -- border = {},
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    -- borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
                    color_devicons = true,
                    set_env = {
                        ["COLORTERM"] = "truecolor",
                    }, -- default = nil,
                },
                pickers = {
                    find_files = {
                        initial_mode = "insert",
                        hidden = true,
                        previewer = true,
                    },
                    live_grep = {
                        -- @usage don't include the filename in the search results
                        initial_mode = "insert",
                        only_sort_text = true,
                        previewer = true,
                    },
                    grep_string = {
                        initial_mode = "insert",
                        only_sort_text = true,
                        previewer = true,
                    },
                    buffers = {
                        initial_mode = "insert",
                        theme = "dropdown",
                        previewer = false,
                        path_display = { "tail" },
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["dd"] = actions.delete_buffer,
                            },
                        },
                    },
                    planets = {
                        show_pluto = true,
                        show_moon = true,
                    },
                    git_files = {
                        hidden = true,
                        show_untracked = true,
                        previewer = true,
                    },
                    colorscheme = {
                        enable_preview = true,
                    },
                    spell_suggest = {
                        theme = "cursor",
                        initial_mode = "normal",
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        -- require("telescope.themes").get_dropdown { }
                        require("telescope.themes").get_cursor({
                            initial_mode = "normal",
                        }),
                    },
                    undo = {
                        use_delta = false,
                        -- use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
                        layout_strategy = "vertical",
                        layout_config = {
                            preview_height = 0.6,
                        },
                        vim_diff_opts = { ctxlen = 8 },
                        entry_format = "state #$ID, $STAT, $TIME",
                        time_format = "",
                        initial_mode = "normal",
                        mappings = {
                            i = {
                                ["<c-Y>"] = require("telescope-undo.actions").yank_additions,
                                ["<c-y>"] = require("telescope-undo.actions").yank_deletions,
                                ["<c-cr>"] = require("telescope-undo.actions").restore,
                            },
                            n = {
                                ["Y"] = require("telescope-undo.actions").yank_additions,
                                ["y"] = require("telescope-undo.actions").yank_deletions,
                                ["<cr>"] = require("telescope-undo.actions").restore,
                            },
                        },
                    },
                    project = {
                        base_dirs = {},
                        hidden_files = true, -- default: false
                        theme = "dropdown",
                        order_by = "recent",
                        search_by = { "title", "path" },
                        initial_mode = "insert",
                        sync_with_nvim_tree = false, -- default false
                        -- default for on_project_selected = find project files
                        on_project_selected = function(prompt_bufnr)
                            -- Do anything you want in here. For example:
                            local project_actions = require("telescope._extensions.project.actions")
                            project_actions.change_working_directory(prompt_bufnr, false)
                        end,
                    },
                    frecency = {
                        matcher = "fuzzy",
                        path_display = { "shorten" },
                        ignore_patterns = { [[*.git\*]], [[*\tmp\*]], "term:*" },
                        ignore_register = function(bufnr)
                            return not vim.bo[bufnr].buflisted
                        end,
                    },
                    -- fzf = {
                    --     fuzzy = true, -- false will only do exact matching
                    --     override_generic_sorter = true, -- override the generic sorter
                    --     override_file_sorter = true, -- override the file sorter
                    --     case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    --     -- the default case_mode is "smart_case"
                    -- },
                    lazy_plugins = {
                        lazy_config = vim.fn.stdpath("config") .. "/init.lua", -- Must be a valid path to the file containing the lazy spec and setup() call.
                    },
                },
            }

            if vim.g.neovide then
                telescope_opts.defaults.winblend = 75
            end

            return telescope_opts
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            pcall(telescope.load_extension, "fzy_native")
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "ui-select")
            pcall(telescope.load_extension, "undo")
            pcall(telescope.load_extension, "project")
            pcall(telescope.load_extension, "noice")
            pcall(telescope.load_extension, "freceny")
            pcall(telescope.load_extension, "live_grep_args")
            pcall(telescope.load_extension, "persisted")
            pcall(telescope.load_extension, "lazy_plugins")

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "TelescopeResults",
                callback = function(ctx)
                    vim.api.nvim_buf_call(ctx.buf, function()
                        vim.fn.matchadd("TelescopeParent", "\t\t.*$")
                        vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
                    end)
                end,
            })
        end,
    },
}
