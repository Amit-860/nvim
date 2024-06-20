local icons = require('icons')
local actions = require("telescope.actions")

local telescope_opts = {
    ---@usage disable telescope completely [not recommended]
    active = true,
    on_config_done = nil,
    -- theme = "dropdown", ---@type telescope_themes
    defaults = {
        prompt_prefix = icons.ui.Telescope .. " ",
        -- selection_caret = icons.ui.Triangle .. " ",
        selection_caret = icons.ui.BoldDividerRight .. " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = nil,
        layout_strategy = nil,
        layout_config = {},
        vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
            "--smart-case", "--hidden", "--glob=!.git/" },
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
                ["<CR>"] = actions.select_default
            },
            n = {
                ["<C-n>"] = actions.move_selection_next,
                ["<C-p>"] = actions.move_selection_previous,
                ["<C-q>"] = function(...)
                    actions.smart_send_to_qflist(...)
                    actions.open_qflist(...)
                end
            }
        },
        file_ignore_patterns = {},
        path_display = { "smart" },
        winblend = 0,
        border = {},
        borderchars = nil,
        color_devicons = true,
        set_env = {
            ["COLORTERM"] = "truecolor"
        } -- default = nil,
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
            previewer = true
        },
        grep_string = {
            initial_mode = "insert",
            only_sort_text = true,
            previewer = true
        },
        buffers = {
            initial_mode = "insert",
            theme = "dropdown",
            previewer = false,
            mappings = {
                i = {
                    ["<C-d>"] = actions.delete_buffer
                },
                n = {
                    ["dd"] = actions.delete_buffer
                }
            }
        },
        planets = {
            show_pluto = true,
            show_moon = true
        },
        git_files = {
            hidden = true,
            show_untracked = true,
            previewer = true
        },
        colorscheme = {
            enable_preview = true
        },
        spell_suggest = {
            theme = "cursor",
            initial_mode = "normal"
        },
    },
    extensions = {
        ["ui-select"] = {
            -- require("telescope.themes").get_dropdown { }
            require("telescope.themes").get_cursor {
                initial_mode = 'normal'
            },
        },
        undo = {
            use_delta = true,
            use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
            layout_strategy = "vertical",
            layout_config = {
                preview_height = 0.6,
            },
            side_by_side = false,
            diff_context_lines = vim.o.scrolloff,
            entry_format = "state #$ID, $STAT, $TIME",
            time_format = "",
            initial_mode = "normal",
            mappings = {
                i = {
                    ["<c-Y>"] = require("telescope-undo.actions").yank_additions,
                    ["<c-y>"] = require("telescope-undo.actions").yank_deletions,
                    ["<c-u>"] = require("telescope-undo.actions").restore
                },
                n = {
                    ["Y"] = require("telescope-undo.actions").yank_additions,
                    ["y"] = require("telescope-undo.actions").yank_deletions,
                    ["u"] = require("telescope-undo.actions").restore
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
            sync_with_nvim_tree = true, -- default false
            -- default for on_project_selected = find project files
            on_project_selected = function(prompt_bufnr)
                -- Do anything you want in here. For example:
                local project_actions = require("telescope._extensions.project.actions")
                project_actions.change_working_directory(prompt_bufnr, false)
            end
        },
        -- file_browser = {
        --     theme = "ivy",
        --     -- disables netrw and use telescope-file-browser in its place
        --     -- layout_config = {
        --     --     prompt_position = "top",
        --     -- },
        --     sorting_strategy = "ascending",
        --     -- layout_strategy = "horizontal",
        --     hijack_netrw = true,
        --     initial_mode = "normal",
        --     grouped = true,
        --     initial_browser = "tree",
        --     mappings = {
        --         ["i"] = {
        --             -- your custom insert mode mappings
        --         },
        --         ["n"] = {
        --             -- your custom normal mode mappings
        --         },
        --     },
        -- },
    }
}


if vim.g.neovide then
    telescope_opts.defaults.winblend = 75
end

require('telescope').setup(telescope_opts)

-- This will load fzy_native and have it override the default file sorter
require("telescope").load_extension("ui-select")
require("telescope").load_extension("undo")
require 'telescope'.load_extension('project')
require 'telescope'.load_extension('noice')
